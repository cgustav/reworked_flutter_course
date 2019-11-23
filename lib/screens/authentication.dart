import 'dart:math';
import 'package:flutter/material.dart';

/*
This screen is built based on this enum.
Components and its placement fit accord 
this feature 
*/

enum AuthMode { SignUp, LogIn }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(215, 117, 255, 0.5),
                      Color.fromRGBO(255, 188, 117, 0.5)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 1])),
          ),

          /*IMPORTANT NOTE
            The use of SingleChildScrollView
            widget is because it helps placing
            the screen right when the device 
            keyboard is open.

            The use of a Column inside provide
            certain properties to place and 
            align children elements easily.
          */
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /*ABOUT TRANSFORM PROP
                    In this case we work with transform
                    property of Container widget, 
                    basically it allows us to chage the 
                    widget shape, rotate it, give to it 
                    a perspective and other cool stuff

                   */
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 2))
                          ]),
                    ),
                  ),
                  Flexible(
                    flex: (deviceSize.width > 600) ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LogIn;
  Map<String, dynamic> _authData = {'email': '', 'password': ''};

  bool _isLoading = false;
  final _passwordController = TextEditingController();

  void setLoading([bool state]) {
    setState(() {
      _isLoading = state;
    });
  }

  void _submit() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    setLoading(true);
    if (_authMode == AuthMode.LogIn) {
      //User logging in
    } else {
      //User signing up
    }
    setLoading(false);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.LogIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.LogIn;
      });
    }
  }

  bool isLogin(AuthMode authmode) => (authmode == AuthMode.LogIn);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Container(
        height: isLogin(_authMode) ? 260 : 320,
        constraints: BoxConstraints(
          minHeight: isLogin(_authMode) ? 260 : 320,
        ),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    return (value.isEmpty || !value.contains('@'))
                        ? 'Invalid email.'
                        : null;
                  },
                  onSaved: (String text) {
                    _authData['email'] = text;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    return (value.isEmpty || value.length < 5)
                        ? 'Invalid email.'
                        : null;
                  },
                  onSaved: (String text) {
                    _authData['password'] = text;
                  },
                ),
                (!isLogin(_authMode))
                    ? TextFormField(
                        enabled: !isLogin(_authMode),
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: isLogin(_authMode)
                            ? null
                            : (String text) =>
                                (text != _passwordController.text)
                                    ? 'Passwords do not match'
                                    : null,
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                (_isLoading)
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text(
                          (isLogin(_authMode) ? 'LOGIN' : 'SIGN UP'),
                        ),
                        onPressed: _submit,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        color: Theme.of(context).primaryColor,
                        textColor:
                            Theme.of(context).primaryTextTheme.button.color,
                      ),
                FlatButton(
                  child: Text(
                      '${isLogin(_authMode) ? 'SIGN UP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
      //child: child,
    );
  }
}