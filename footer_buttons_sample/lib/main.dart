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
  String _value = '';

  void _onClick(String value) => setState(() => _value = value);

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
            children: <Widget>[Text(_value)],
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        IconButton(
          icon: Icon(Icons.timer),
          onPressed: () => _onClick('Button 1'),
        ),
        IconButton(
          icon: Icon(Icons.people),
          onPressed: () => _onClick('Button 2'),
        ),
        IconButton(
          icon: Icon(Icons.map),
          onPressed: () => _onClick('Button 3'),
        ),
      ],
    );
  }
}
