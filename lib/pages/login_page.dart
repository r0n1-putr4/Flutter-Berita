import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/pages/home_page.dart';
import 'package:flutter_berita/pages/register_page.dart';
import 'package:flutter_berita/utils/costume_input.dart';

import '../utils/session.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  var username = TextEditingController();
  var password = TextEditingController();
  var fullName = TextEditingController();
  var email = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void login() async {
    // String username = _usernameController.text;
    // String password = _passwordController.text;

    await SessionManager.saveSession("fake_token_123");
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("data "),
                SizedBox(height: 30),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                CostumeInput(
                  label: "Username",
                  textEditingController: username,
                  icon: Icons.person,
                  textHint: "r0n1",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 10),
                CostumeInput(
                  label: "Password",
                  textEditingController: password,
                  obscureText: true,
                  icon: Icons.key,
                  textHint: "*****",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      login();
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
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
