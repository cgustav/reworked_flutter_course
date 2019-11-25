import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/models/http_exception.dart';
import 'package:reworked_flutter_course/providers/auth.dart';
import 'package:reworked_flutter_course/screens/products_overview_screen.dart';

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
                      child: Text(
                        'MyShop',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
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

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.LogIn;
  Map<String, dynamic> _authData = {'email': '', 'password': ''};

  bool _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Size> _heightAnimation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    /*
    AnimationController takes two important
    arguments: 
      -The first one, vsync is an argument
       were we give to the animation controller
       a pointer at the widget in the end
       which should watch, and only when 
       that widget is really visible in the
       screen, the animation should play.
       In this way this optimizes prformance
       because it ensures that we really 
       only animate what is visible to the
       user.
     - The second one is the duration that
       takes go forward or backward in our
       animation.

     */
    _controller = AnimationController(
        //pointing to this widget (AuthCard)
        vsync: this,
        duration: Duration(milliseconds: 300));

    /*
        The Tween class is an object that
        instantiated gives you the tools
        two create an animation based in 
        two values. 
        Tween is more like a generic class
        because there are differents things
        you can animate.

        CurvedAnimation is a class that gives
        the entire content of an animation
        in particular. 

        Curves.linear ensures that the distri-
        bution on our duration of the aninmation
        will be a constant, or linear.
         */
    _heightAnimation = Tween<Size>(
            begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _heightAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: Text('An error occurred!'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  void setLoading([bool state]) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    setLoading(true);

    try {
      if (_authMode == AuthMode.LogIn)
        //User logging in
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData['email'], _authData['password']);
      else
        //User signing up
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);

      // Navigator.of(context)
      //     .pushReplacementNamed(ProductsOverviewScreen.routeName);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed.';
      String excMsg = error.toString();

      if (excMsg.contains('EMAIL_EXISTS'))
        errorMessage = 'This email address is already in use.';
      else if (excMsg.contains('INVALID_EMAIL'))
        errorMessage = 'This is not a valid email address.';
      else if (excMsg.contains('WEAK_PASSWORD'))
        errorMessage = 'This password is too weak.';
      else if (excMsg.contains('EMAIL_NOT_FOUND'))
        errorMessage = 'Could not find a user with given email.';
      else if (excMsg.contains('INVALID_PASSWORD'))
        errorMessage = 'Invalid password.';

      _showErrorDialog(errorMessage);
    } catch (error, stackTrace) {
      print('ERROR      : $error');
      print('STACKTRACE : $stackTrace');

      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setLoading(false);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.LogIn) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.LogIn;
      });
      _controller.reverse();
    }
  }

  bool isLogin(AuthMode authmode) => (authmode == AuthMode.LogIn);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      height: _heightAnimation.value.height,
      constraints: BoxConstraints(minHeight: _heightAnimation.value.height),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                                      ? 'Passwords do not match.'
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 4.0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        //child: child,
      ),
    );
  }
}
