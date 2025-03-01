import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  bool? is_login;
  String? idUser;
  String? email;
  String? fullName;

  Future<void> saveSession(String idUser, String email, String fullName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("is_login", true);
    pref.setString("idUser", idUser);
    pref.setString("email", email);
    pref.setString("fullName", fullName);
  }

  Future getSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    is_login = pref.getBool("is_login");
    idUser = pref.getString("idUser");
    email = pref.getString("email");
    fullName = pref.getString("fullName");
  }
  //remove --> logout
  Future clearSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

//instance class biar d panggil
SessionManager sessionManager = SessionManager();