import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
              onChanged: (String value) {
                setState(() {
                  email = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password', ),
              onChanged: (String value) {
                setState(() {
                  password = value;
                });
              },
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            Center(
              child: RaisedButton(
                child: Text('LOGIN'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/products');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
