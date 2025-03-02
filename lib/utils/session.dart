import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveSession(String id, String username, String fullname, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('username', username);
    await prefs.setString('fullname', fullname);
    await prefs.setString('email', email);
  }

  // Get user session (returns a map with user_token and id_user)
  static Future<Map<String, String?>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('id'),
      'username': prefs.getString('username'),
      'fullname': prefs.getString('fullname'),
      'email': prefs.getString('email'),
    };
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('username');
    await prefs.remove('fullname');
    await prefs.remove('email');
  }
}
