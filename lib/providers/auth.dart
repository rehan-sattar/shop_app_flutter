import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return getToken != null;
  }

  String get getToken {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get getUserId {
    return _userId;
  }

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
      var responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      _userId = responseData['localId'];
      _autoLogout();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      });
      pref.setString("userData", userData);
    } catch (err) {
      print(err);
      throw (err);
    }
  }

  Future<bool> tryLoginAutomatically() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey("userData")) {
        return false;
      }
      final extractedData = json.decode(prefs.getString("userData"));
      final expiryDate = DateTime.parse(extractedData["expiryDate"]);

      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = extractedData['token'];
      _userId = extractedData['userId'];
      _expiryDate = expiryDate;
      _autoLogout();
      notifyListeners();
      return true;
    } catch (err) {
      print(err);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
