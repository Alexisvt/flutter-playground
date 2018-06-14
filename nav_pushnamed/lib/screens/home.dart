import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page')
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('You are in home screen :)'),
              RaisedButton(onPressed: () => Navigator.of(context).pushNamed('/Second'), child: Text('Next'),),
            ],
          ),
        ),
      ),
    );
  }
}
