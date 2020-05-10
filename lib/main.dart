import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_widget.dart';

void main() => runApp(App());

class App extends StatelessWidget {

//  Widget build(BuildContext context) {
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//      statusBarColor: themeColour,
//      systemNavigationBarColor: Colors.grey[850],
//    ));

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
      title: 'Pincer',
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}