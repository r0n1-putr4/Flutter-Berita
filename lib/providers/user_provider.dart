import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/login_model.dart';
import '../models/register_model.dart';
import '../utils/base_url.dart';
import '../utils/session.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _message = "";

  String get message => _message;

  bool _success = false;

  bool get success => _success;

  Data? _user;

  Data? get user => _user;

  Future<String> register(
    String username,
    String password,
    String fullName,
    String email,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      http.Response hasil = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/users"),
        body: {
          "username": username,
          "password": password,
          "fullname": fullName,
          "email": email,
        },
      );

      final registerModel = registerModelFromJson(hasil.body);
      _success = registerModel.success;
      _message = registerModel.message;

      return _message;
    } catch (e) {
      _message = "Error : $e";
      return _message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> login(String username, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      http.Response hasil = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/users/login"),
        body: {"username": username, "password": password},
      );
      final loginModel = loginModelFromJson(hasil.body);

      _success = loginModel.success;
      _message = loginModel.message;

      if (loginModel.success) {
        _user = loginModel.data;
      }

      return _message;
    } catch (e) {
      _message = "Error : $e";
      return _message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
