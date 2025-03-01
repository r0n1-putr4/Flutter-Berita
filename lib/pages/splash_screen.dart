import 'package:flutter/material.dart';
import 'package:flutter_berita/pages/home_page.dart';
import 'package:flutter_berita/pages/login_page.dart';

import '../utils/session.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession();
  }

  void checkSession() async {
    String? token = await SessionManager.getSession();
    Future.delayed(Duration(seconds: 2), () {
      if (token != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
