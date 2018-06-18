import 'package:flutter/material.dart';

class Authenticator extends StatefulWidget {
  final ValueChanged<bool> onAthenticated;

  Authenticator({Key key, this.onAthenticated});

  @override
  _AuthenticatorState createState() =>
      _AuthenticatorState(onAuthenticated: onAthenticated);
}

class _AuthenticatorState extends State<Authenticator> {
  TextEditingController _user;
  TextEditingController _pass;
  final ValueChanged<bool> onAuthenticated;

  _AuthenticatorState({Key key, this.onAuthenticated});

  @override
  void initState() {
    super.initState();
    _pass = TextEditingController();
    _user = TextEditingController();
  }

  void _onPressed() {
    if (_user.text != 'user' || _pass.text != '1234') {
      onAuthenticated(false);
    } else {
      onAuthenticated(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _user,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _pass,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: _onPressed,
                child: Text('Login'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
