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
  int _value = 0;

  _subtract() {
    setState(() {
      _value--;
    });
  }

  _increment() {
    setState(() {
      _value++;
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
              new Text('Value = ${_value.toString()}'),
              new IconButton(onPressed: _increment, icon: new Icon(Icons.add)),
              new IconButton(onPressed: _subtract, icon: new Icon(Icons.remove))
            ],
          ),
        ),
      ),
    );
  }
}
