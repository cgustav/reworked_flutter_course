import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:reworked_flutter_course/helpers/http_resources.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reworked_flutter_course/models/http_exception.dart';

class Auth with ChangeNotifier {
  /* 
  Tipically a token expires
  after one hour(beacause as
  a security mechanism) so it 
  will change constantly.
   */
  String _token;
  /*
   That token's expiry time 
   is expressed with a specific
   format to allow to flutter 
   read and understand this expiry
   date. Then we are capable to 
   auto-renegotiate valid tokens.
   */
  DateTime _expiryDate;

  /*
   An unique user id allow us
   to identify inmediatly an user
   */
  String _userId;

  Timer _authTimer;

  final HttpResources resources = HttpResources();

  bool get isAuth => (token != null);

  String get token => (_expiryDate != null &&
          _expiryDate.isAfter(DateTime.now()) &&
          _token != null)
      ? _token
      : null;

  String get userId => _userId;

  Future<void> _authenticate(String email, String password,
      {@required String action, bool returnSecureToken = true}) async {
    var response;
    Map container = {
      'email': email,
      'password': password,
      'returnSecureToken': returnSecureToken
    };

    try {
      response = (action == 'logIn')
          ? await HttpResources.firestoreToolKit
              .signInWithPassword(body: container)
          : await HttpResources.firestoreToolKit.signUp(body: container);

      final responseData = json.decode(response.body);

      if (responseData['error'] != null)
        throw HttpException(responseData['error']['message']);

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      //setting the expiry time of our
      //token to manage that on the
      //client-side.
      _autoLogOut();

      notifyListeners();

      //using our sharedPreferences instance
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userId,
        'expiryDate': _expiryDate.toIso8601String()
      });
      //Saving our session data on local device
      //storage.
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return await _authenticate(email, password, action: 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return await _authenticate(email, password, action: 'logIn');
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();

    //If there aren't any userData object
    //stored on the device then stop the
    //auto-login process
    if (!prefs.containsKey('userData')) return false;

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    //If the user token is already expired
    //then stop the autoLogIn process.
    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) _authTimer.cancel();

    final timetoExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timetoExpiry), logOut);
  }
}
