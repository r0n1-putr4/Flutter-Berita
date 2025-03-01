import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveSession(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }

  static Future<String?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }
}

//instance class biar d panggil
SessionManager sessionManager = SessionManager();