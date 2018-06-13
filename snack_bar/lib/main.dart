import 'package:flutter/material.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();

  void _showbar() {
    _scaffoldstate.currentState.showSnackBar(SnackBar(
      content: Text('Hello world'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
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
                onPressed: _showbar,
                child: Text('Click me'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
