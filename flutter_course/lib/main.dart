import 'package:flutter/material.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurple,
      ),
      home: AuthPage(),
      routes: {'/admin': (BuildContext context) => ProductsAdminPage()},
    );
  }
}
