
import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/second.dart';
import './screens/third.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Navigation',
    routes: {
      // All available pages
      '/Home': (BuildContext context) => Home(),
      '/Second': (BuildContext context) => Second(),
      '/Third': (BuildContext context) => Third(),
    },
    home: Home(), // first play displayed
  );
}