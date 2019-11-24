import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpResources {
  static FirestoreResources firestoreDB = FirestoreResources();
  static FirestoreToolKit firestoreToolKit =
      FirestoreToolKit(apiKey: 'AIzaSyCQXcShOoY8wsf6CW-yus46K5rO23yk480');
}

class FirestoreResources {
  String resourceUrl({
    String sufix = '',
    String authToken = '',
    String extraElements = '',
    @required String collection,
  }) {
    if (authToken != null && authToken.isNotEmpty)
      authToken = '?auth=$authToken';

    // if (extraElements != null &&
    //     extraElements.isNotEmpty &&
    //     !extraElements.contains('&')) extraElements = '&' + extraElements;

    return 'https://reworked-flutter-course.firebaseio.com/$collection$sufix.json$authToken$extraElements';
  }

  String get baseUrl => 'https://reworked-flutter-course.firebaseio.com';
}

class FirestoreToolKit {
  String _apiKey;

  FirestoreToolKit({@required String apiKey}) {
    if (apiKey == null || apiKey.isEmpty)
      throw Exception(
          'Cannot Instantiate FirestoreToolKit Class without a valid API Web Token.');

    _apiKey = apiKey;
  }

  String get _authUrl =>
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=${this._apiKey}';

  String get _passwordAuthUrl =>
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${this._apiKey}';

  String get _signUpUrl =>
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${this._apiKey}';

  // Future<dynamic> signInWithCustomToken({dynamic body}) async {
  //   var response;
  //   try {
  //     response = await http.post(this._authUrl, body: json.encode(body));

  //     if (response.statusCode != 200 && response.statusCode != 201)
  //       throw Exception(response.body);

  //     return response;
  //   } catch (error) {
  //     // print('SIGN IN WITH CUSTOM TOKEN FAILED');
  //     // print('REASON: $error');
  //     return (response != null) ? response : throw error;
  //   }
  // }

  Future<dynamic> signInWithPassword({dynamic body}) async =>
      await http.post(this._passwordAuthUrl, body: json.encode(body));

  Future<dynamic> signUp({dynamic body}) async =>
      await http.post(this._signUpUrl, body: json.encode(body));
}
