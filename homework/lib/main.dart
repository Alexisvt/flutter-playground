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
  String _tempValue = '';

  void _onTextChange(String value) => setState(() => _tempValue = value);

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
              new Text('Your value is: $_value'),
              new TextField(
                onChanged: _onTextChange,
              ),
              new Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new RaisedButton(
                  child: new Text('Show entered text'),
                  onPressed: _onButtonPress,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onButtonPress() {
    setState(() {
      _value = _tempValue;
    });
  }
}
