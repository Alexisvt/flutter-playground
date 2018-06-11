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
  String _value = '';

  void _onClicked() => setState(() => _value = DateTime.now().toString());

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
            children: <Widget>[new Text(_value)],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _onClicked,
        mini: true,
        child: new Icon(Icons.timer),
      ),
    );
  }
}
