import 'package:flutter/material.dart';
import 'placeholder_widget.dart';

var themeColour = Colors.red[900];
var accentColour = Colors.red;

String pageTitle = 'Hottest';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: _children[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(Icons.search),
        backgroundColor: themeColour,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            title: Text('Trending'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text('Latest'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            pageTitle = 'Trending';
          }
          break;
        case 1:
          {
            pageTitle = 'Latest';
          }
          break;
        case 2:
          {
            pageTitle = 'Settings';
          }
          break;
      }
    });
  }
}