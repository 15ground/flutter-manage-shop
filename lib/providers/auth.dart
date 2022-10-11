import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopping_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBW6OX2eYvoQ1DGEd9HNtDXG2GdB2qJF-s');
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw HttpException(resData['error']['message']);
      }
      _token = resData['idToken'];
      _userId = resData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(resData['expiresIn'])));
      // _autoSignOut();
      notifyListeners();
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  String get userId {
    return _userId ?? '';
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void signOut() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    // if (_authTimer != null) {
    //   _authTimer.cancel();
    //   _authTimer = null;
    // }
    notifyListeners();
  }

  // void _autoSignOut() {
  //   if (_authTimer == null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: 5), signOut);
  // }
}
