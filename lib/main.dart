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
    ListView(
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.amber[600],
          child: const Center(child: Text('Entry A')),
        ),
        Container(
          height: 50,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 50,
          color: Colors.amber[400],
          child: const Center(child: Text('Entry C')),
        ),
      ],
    ),
    Text('Latest'),
    ListView(
      children: <Widget>[
        Text('Settings')
      ],
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
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // onPressed code goes here
        },
        child: Icon(Icons.search),
        backgroundColor: themeColour,
      ),
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

//body: Center(
//child: _widgetOptions.elementAt(_selectedIndex),
//),
