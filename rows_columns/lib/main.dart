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
  TextEditingController _user = TextEditingController();
  TextEditingController _pass = TextEditingController();

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
              Text('Please Login'),
              Row(
                children: <Widget>[
                  Text('Username: '),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextField(
                        controller: _user,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text('Password: '),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: TextField(
                      controller: _pass,
                      obscureText: true,
                    ),
                  ))
                ],
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: RaisedButton(
                  child: Text('Click me!'),
                  onPressed: () => print('Login ${_user.text}'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
