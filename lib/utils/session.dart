import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveSession(String token, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
    await prefs.setString('id_user', userId);
  }

  // Get user session (returns a map with user_token and id_user)
  static Future<Map<String, String?>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'user_token': prefs.getString('user_token'),
      'id_user': prefs.getString('id_user'),
    };
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('id_user');
  }
}

//instance class biar d panggil
SessionManager sessionManager = SessionManager();