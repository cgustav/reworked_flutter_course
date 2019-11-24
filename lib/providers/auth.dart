import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:reworked_flutter_course/helpers/http_resources.dart';
import 'dart:convert';

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

      notifyListeners();
      //return response;
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
}
