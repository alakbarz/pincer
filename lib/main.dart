import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() => runApp(MyApp());

var themeColour = Colors.red[900];
var accentColour = Colors.red;

var _pageTitle = 'Trending';

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Pincer';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData.from(
        colorScheme: ColorScheme.dark(
            primary: themeColour,
            secondary: accentColour,
            tertiary: accentColour));
    return MaterialApp(
      theme: theme,
      darkTheme: theme,
      title: _title,
      home: PincerStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PincerStatefulWidget extends StatefulWidget {
  PincerStatefulWidget({Key key}) : super(key: key);

  @override
  PincerStatefulWidgetState createState() => PincerStatefulWidgetState();
}

class PincerStatefulWidgetState extends State<PincerStatefulWidget> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    buildLobstersList(FetchType.Hottest),
    buildLobstersList(FetchType.Newest),
    buildLobstersList(FetchType.Active),

    //Settings
    ListView(
      children: <Widget>[
        CheckboxListTile(
          title: Text('Animate Slowly'),
          subtitle: Text('Slows down animations by a factor of 10'),
          value: timeDilation != 1.0,
          onChanged: (bool value) {
            //            setState(() {
            //              timeDilation = value ? 10.0 : 1.0;
            //            });
          },
        ),
        CheckboxListTile(
          title: Text('Dark Mode'),
          subtitle: Text('Woah'),
          value: false,
          onChanged: (bool value) {},
        ),
      ],
    ),
  ];

  // Setting the title of the AppBar depending on which page is chosen
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          {
            _pageTitle = 'Trending';
          }
          break;
        case 1:
          {
            _pageTitle = 'Latest';
          }
          break;
        case 2:
          {
            _pageTitle = 'Active';
          }
          break;
        case 3:
          {
            _pageTitle = 'Settings';
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_pageTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                // TODO onPressed for AppBar refresh button
              },
            )
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color: accentColour),
          unselectedIconTheme: IconThemeData(color: accentColour),
          unselectedLabelStyle: TextStyle(color: themeColour),
          selectedLabelStyle: TextStyle(color: themeColour),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Trending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: 'Latest',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_upward_sharp),
              label: 'Active',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}

// Extracts the top level domain from a URL
String cutDomain(String url) {
  try {
    var uri = Uri.parse(url);
    if (uri.host == "") {
      return 'Discussion Thread';
    }
    return uri.host;
  } on FormatException {
    return "Unknown";
  }
}

ListView buildLobstersList(FetchType type) {
  return ListView(
    children: <Widget>[
      new FutureBuilder<List<Newest>>(
          future: fetchLobsters(type),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return LinearProgressIndicator();
            } else if (snapshot.hasError) {
              return snapshot.error;
            }

            List<Newest> posts = snapshot.data;
            return new Column(
                children: posts
                    .map((post) => new ListTile(
                          onTap: () async {
                            if (post.url == "") {
                              await launchUrlString(post.commentsUrl);
                            } else {
                              await launchUrlString(post.url);
                            }
                          },
                          title: Text(post.title),
                          subtitle: Text(post.submitterUser.username +
                              ' · ' +
                              cutDomain(post.url) +
                              ' · ▲' +
                              post.score.toString()),
                          trailing: IconButton(
                              icon: Column(children: [
                                Icon(Icons.comment, size: 20),
                                Text(post.commentCount.toString(),
                                    style: TextStyle(fontSize: 8))
                              ]),
                              padding: EdgeInsets.all(2),
                              onPressed: (() async {
                                await launchUrlString(post.commentsUrl);
                              })),
                        ))
                    .toList());
          })
    ],
  );
}

enum FetchType {
  Hottest,
  Newest,
  Active,
}

Future<List<Newest>> fetchLobsters(FetchType type) async {
  String file;
  switch (type) {
    case FetchType.Hottest:
      file = "hottest.json";
      break;
    case FetchType.Newest:
      file = "newest.json";
      break;
    case FetchType.Active:
      file = "active.json";
      break;
  }
  var uri = Uri.https("lobste.rs", file);
  final response = await http.get(uri);
  var responseJson = json.decode(response.body);

  if (response.statusCode == 200) {
    return (responseJson as List).map((e) => Newest.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load newest stories');
  }
}

class Newest {
  String shortId;
  String shortIdUrl;
  String createdAt;
  String title;
  String url;
  int score;
  int upvotes;
  int downvotes;
  int commentCount;
  String description;
  String commentsUrl;
  SubmitterUser submitterUser;
  List<String> tags;

  Newest(
      {this.shortId,
      this.shortIdUrl,
      this.createdAt,
      this.title,
      this.url,
      this.score,
      this.upvotes,
      this.downvotes,
      this.commentCount,
      this.description,
      this.commentsUrl,
      this.submitterUser,
      this.tags});

  Newest.fromJson(Map<String, dynamic> json) {
    shortId = json['short_id'];
    shortIdUrl = json['short_id_url'];
    createdAt = json['created_at'];
    title = json['title'];
    url = json['url'];
    score = json['score'];
    upvotes = json['upvotes'];
    downvotes = json['downvotes'];
    commentCount = json['comment_count'];
    description = json['description'];
    commentsUrl = json['comments_url'];
    submitterUser = json['submitter_user'] != null
        ? new SubmitterUser.fromJson(json['submitter_user'])
        : null;
    tags = json['tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['short_id'] = this.shortId;
    data['short_id_url'] = this.shortIdUrl;
    data['created_at'] = this.createdAt;
    data['title'] = this.title;
    data['url'] = this.url;
    data['score'] = this.score;
    data['upvotes'] = this.upvotes;
    data['downvotes'] = this.downvotes;
    data['comment_count'] = this.commentCount;
    data['description'] = this.description;
    data['comments_url'] = this.commentsUrl;
    if (this.submitterUser != null) {
      data['submitter_user'] = this.submitterUser.toJson();
    }
    data['tags'] = this.tags;
    return data;
  }
}

class SubmitterUser {
  String username;
  String createdAt;
  bool isAdmin;
  String about;
  bool isModerator;
  int karma;
  String avatarUrl;
  String invitedByUser;

  SubmitterUser(
      {this.username,
      this.createdAt,
      this.isAdmin,
      this.about,
      this.isModerator,
      this.karma,
      this.avatarUrl,
      this.invitedByUser});

  SubmitterUser.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    createdAt = json['created_at'];
    isAdmin = json['is_admin'];
    about = json['about'];
    isModerator = json['is_moderator'];
    karma = json['karma'];
    avatarUrl = json['avatar_url'];
    invitedByUser = json['invited_by_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['created_at'] = this.createdAt;
    data['is_admin'] = this.isAdmin;
    data['about'] = this.about;
    data['is_moderator'] = this.isModerator;
    data['karma'] = this.karma;
    data['avatar_url'] = this.avatarUrl;
    data['invited_by_user'] = this.invitedByUser;
    return data;
  }
}
