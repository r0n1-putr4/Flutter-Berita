

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveSession(int id, String username, String fullname, String email, String gambar) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', id); // Simpan sebagai Integer
    await prefs.setString('username', username);
    await prefs.setString('fullname', fullname);
    await prefs.setString('email', email);
    await prefs.setString('gambar', gambar);
  }

  // Get user session (returns a map with user_token and id_user)
  static Future<Map<String, dynamic>> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('id'), // Baca langsung sebagai Integer
      'username': prefs.getString('username'),
      'fullname': prefs.getString('fullname'),
      'email': prefs.getString('email'),
      'gambar': prefs.getString('gambar'),
    };
  }

  // Clear session (logout)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('username');
    await prefs.remove('fullname');
    await prefs.remove('email');
    await prefs.remove('gambar');
  }
}
