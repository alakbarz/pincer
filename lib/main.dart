import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

var themeColour = Colors.red[900];
var accentColour = Colors.red;

var _pageTitle = 'Trending';

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Pincer';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: themeColour,
        accentColor: accentColour,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: themeColour,
        accentColor: accentColour,
      ),
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    ListView(
      children: <Widget>[
        new FutureBuilder<List<Newest>>(
            future: fetchHottest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Newest> posts = snapshot.data;
                return new Column(
                    children: posts
                        .map((post) => new ListTile(
                            onTap: () async {
                              if (await canLaunch(post.url.toString())) {
                                await launch(post.url.toString());
                              }
                            },
                            title: Text(post.title),
                            subtitle: Text(post.submitterUser.username +
                                ' · ' +
                                cutDomain(post.url) +
                                ' · ▲' +
                                post.upvotes.toString())))
                        .toList());
              } else if (snapshot.hasError) {
                return snapshot.error;
              }

              return LinearProgressIndicator();
            })
      ],
    ),

    // Latest
    ListView(
      children: <Widget>[
        new FutureBuilder<List<Newest>>(
            future: fetchNewest(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Newest> posts = snapshot.data;
                return new Column(
                    children: posts
                        .map((post) => new ListTile(
                            onTap: () async {
                              if (await canLaunch(post.url.toString())) {
                                await launch(post.url.toString());
                              }
                            },
                            title: Text(post.title),
                            subtitle: Text(post.submitterUser.username +
                                ' · ' +
                                cutDomain(post.url) +
                                ' · ▲' +
                                post.upvotes.toString())))
                        .toList());
              } else if (snapshot.hasError) {
                return snapshot.error;
              }

              return LinearProgressIndicator();
            })
      ],
    ),

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
            _pageTitle = 'Settings';
          }
          break;
      }
    });
  }

  // Extracts the top level domain from a URL
  static String cutDomain(String url) {
    RegExp exp =
        new RegExp(r'^(?:https?:\/\/)?(?:[^@\n]+@)?(?:www\.)?([^:\/\n\?\=]+)');

    RegExpMatch match = exp.firstMatch(url);

    if (match == null){
      return 'Discussion Thread';
    }

    return match.group(1);
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text('Trending'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text('Latest'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

Future<List<Newest>> fetchNewest() async {
  final response = await http.get('https://lobste.rs/newest.json');
  var responseJson = json.decode(response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
//    return Newest.fromJson(json.decode(response.body));
    return (responseJson as List).map((e) => Newest.fromJson(e)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load newest stories');
  }
}

Future<List<Newest>> fetchHottest() async {
  final response = await http.get('https://lobste.rs/hottest.json');
  var responseJson = json.decode(response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
//    return Newest.fromJson(json.decode(response.body));
    return (responseJson as List).map((e) => Newest.fromJson(e)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
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
