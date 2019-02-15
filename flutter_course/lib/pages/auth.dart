import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/ui_elements/adapative_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;
  AnimationController _controller;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0.0, -2.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            image: _buildBackgroundImage(),
          ),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildPasswordTextField(),
                    SizedBox(height: 10.0),
                    _buildPasswordConfirmTextField(),
                    _buildAcceptSwitch(),
                    SizedBox(height: 10.0),
                    FlatButton(
                      child: Text(
                          'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                      onPressed: () {
                        if (_authMode == AuthMode.Login) {
                          setState(() {
                            _authMode = AuthMode.Signup;
                          });
                          _controller.forward();
                        } else {
                          setState(() {
                            _authMode = AuthMode.Login;
                          });
                          _controller.reverse();
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isLoading
                            ? AdapativeProgressIndicator()
                            : RaisedButton(
                                textColor: Colors.white,
                                child: Text(_authMode == AuthMode.Login
                                    ? 'LOGIN'
                                    : 'SIGNUP'),
                                onPressed: () =>
                                    _submitForm(model.authenticate),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SwitchListTile _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accep terms'),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Password',
      ),
      validator: (String value) {
        if (value.isEmpty || value.length < 4) {
          return "Password is required and should be 4+ character long.";
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
      controller: _passwordTextController,
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-Mail',
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return "E-mail is required and should be a valid E-mail";
        }
      },
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: TextFormField(
          enabled: _authMode == AuthMode.Signup,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (String value) {
            if ((_authMode != AuthMode.Login) &&
                (_passwordTextController.text != value)) {
              return "Password do not match.";
            }
          },
          obscureText: true,
        ),
      ),
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.5),
        BlendMode.dstATop,
      ),
      image: AssetImage('assets/background.jpg'),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();

    final Map<String, dynamic> successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);

    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An Error Ocurred!'),
              content: Text(successInformation['message']),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
}
