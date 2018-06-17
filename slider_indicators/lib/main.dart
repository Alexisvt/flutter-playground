import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _value = 0.0;

  void _onChanged(double value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slider sample'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Slider(
                value: _value,
                onChanged: _onChanged,
              ),
              Container(
                padding: EdgeInsets.all(32.0),
                child: LinearProgressIndicator(
                  value: _value,
                  valueColor: AlwaysStoppedAnimation(Colors.red),
                ),
              ),
              Container(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(
                  value: _value,
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
