import 'package:flutter/material.dart';

class Third extends StatefulWidget {
  @override
  _ThirdState createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Third page')
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('You are in Third screen :)'),
              RaisedButton(onPressed: () => Navigator.of(context).pushNamed('/Second'), child: Text('Back'),)
            ],
          ),
        ),
      ),
    );
  }
}
