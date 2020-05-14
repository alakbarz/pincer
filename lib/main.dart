import 'package:flutter/material.dart';

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
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('News Story Number'),
          subtitle: Text('This is a subtitle for the story number'),
          trailing: Container(
            child: Text('$index'),
          ),
          onTap: () {
            // TODO onTap for ListView story selection
          },
          onLongPress: () {
            // TODO onLongPress for ListView story selection
          },
        );
      },
    ),
    Text('Latest'),
    ListView(
      children: <Widget>[Text('Settings')],
    ),
  ];

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

//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          // onPressed code goes here
//        },
//        child: Icon(Icons.search),
//        backgroundColor: themeColour,
//      ),
