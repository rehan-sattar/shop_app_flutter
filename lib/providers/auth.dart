import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expriryTime;
  String _userId;

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    try {
      var url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBWKQCoDjhzEsM0NAgNtEEb9y8h5rvV70g';
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      print(json.decode(response.body));
    } catch (err) {
      throw (err);
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      return _authenticate(email, password, 'signUp');
    } catch (err) {
      throw (err);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      return _authenticate(email, password, 'signInWithPassword');
    } catch (err) {
      throw (err);
    }
  }
}
