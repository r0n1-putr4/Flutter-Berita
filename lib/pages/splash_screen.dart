import 'package:flutter/material.dart';
import 'package:flutter_berita/pages/home_page.dart';
import 'package:flutter_berita/pages/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => LoginPage(),
        ),
      );
    });

    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),
            ],
          ),
        ),
      ),
    );
  }
}
