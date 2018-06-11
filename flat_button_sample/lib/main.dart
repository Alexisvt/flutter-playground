import 'package:flutter/material.dart';

main(List<String> args) {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _value = 'The time is';
  String _time = '';

  _onPressed() {
    setState(() {
      _time = new DateTime.now().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Name here'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text(_value),
              new Text(_time),
              new RaisedButton(
                onPressed: _onPressed,
                child: new Text('Clicked me in raise button'),
              ),
              new FlatButton(
                onPressed: _onPressed,
                child: new Text('Clicked me in Flat Button'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
