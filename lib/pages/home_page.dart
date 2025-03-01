import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/pages/login_page.dart';
import 'package:flutter_berita/utils/session.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token = "";
  String userId = "";

  void logout() async{
    await SessionManager.clearSession();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _loadSession() async {
    Map<String, String?> session = await SessionManager.getSession();
    setState(() {
      token = session['user_token'] ?? "No Token";
      userId = session['user_id'] ?? "No User ID";
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSession();
    // getLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("data $token"),
            ElevatedButton(
              onPressed: () {
                setState(() {

                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                // Full width, height: 50
                backgroundColor: Colors.red,
                // Change button color
                foregroundColor: Colors.white, // Change text color
              ),
              child: Text("SAVE"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  logout();
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                // Full width, height: 50
                backgroundColor: Colors.red,
                // Change button color
                foregroundColor: Colors.white, // Change text color
              ),
              child: Text("Logout"),
            ),


          ],
        ),
      ),
    );
  }
}
