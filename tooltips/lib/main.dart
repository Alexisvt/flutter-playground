import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _value = 'Nothing yet';

  void _onPressed() => setState(() => _value = new DateTime.now().toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tooltip sample'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(_value),
              IconButton(
                icon: Icon(Icons.timer),
                onPressed: _onPressed,
                tooltip: 'Click me',
              )
            ],
          ),
        ),
      ),
    );
  }
}
