import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/providers/user_provider.dart';
import 'package:flutter_berita/utils/costume_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';

import '../utils/base_url.dart';
import '../utils/costume_input.dart';
import 'package:flutter_berita/models/register_model.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  var username = TextEditingController();
  var password = TextEditingController();
  var fullName = TextEditingController();
  var email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  "Register",
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
                SizedBox(height: 10),
                CostumeInput(
                  label: "Fullname",
                  textEditingController: fullName,
                  icon: Icons.key,
                  textHint: "Roni Putra",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 10),
                CostumeInput(
                  label: "Email",
                  textEditingController: email,
                  icon: Icons.email,
                  textHint: "rn.putra@gmail.com",
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    // Full width, height: 50
                    backgroundColor: Colors.red,
                    // Change button color
                    foregroundColor: Colors.white, // Change text color
                  ),
                  onPressed:
                  provider.isLoading
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {


                      String pesan = await context
                          .read<UserProvider>()
                          .register(username.text,password.text,fullName.text,email.text);

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("$pesan")));

                      if(provider.success){
                        Navigator.pushNamed(context, "/login");
                      }
                    }
                  },
                  child:
                  provider.isLoading
                      ? CircularProgressIndicator()
                      : Text("SAVE"),
                ),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Login",
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
                                    builder: (_) => const LoginPage(),
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
