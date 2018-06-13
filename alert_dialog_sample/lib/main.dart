import 'package:flutter/material.dart';
import 'dart:async';

main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future _showAlert(BuildContext context, String message) => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Ok'),
              )
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name here'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Add Widgets here'),
              RaisedButton(
                onPressed: () {
                  _showAlert(context, 'Hello world');
                },
                child: Text('Click me'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
