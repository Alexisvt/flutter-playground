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

enum Answer { YES, NO, MAYBE }

class _MyAppState extends State<MyApp> {
  String _value = '';

  void _setValue(String value) => setState(() => _value = value);

  Future _askUser() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text('Do you like Flutter'),
              children: <Widget>[
                SimpleDialogOption(
                  child: Text('Yes!!!'),
                  onPressed: () {
                    Navigator.pop(context, Answer.YES);
                  },
                ),
                SimpleDialogOption(
                  child: Text('NO!!!'),
                  onPressed: () {
                    Navigator.pop(context, Answer.NO);
                  },
                ),
                SimpleDialogOption(
                  child: Text('MAYBE!!!'),
                  onPressed: () {
                    Navigator.pop(context, Answer.MAYBE);
                  },
                )
              ],
            ))) {
      case Answer.YES:
        _setValue('YES');
        break;
      case Answer.NO:
        _setValue('No!');
        break;
      case Answer.MAYBE:
        _setValue('Maybe :|');
        break;
      default:
    }
  }

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
              Text(_value),
              RaisedButton(
                onPressed: _askUser,
                child: Text('Click me'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
