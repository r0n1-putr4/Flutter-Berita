import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/pages/login_page.dart';
import 'package:flutter_berita/utils/costume_button.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../utils/base_url.dart';
import '../utils/costume_input.dart';
import 'package:flutter_berita/models/register_model.dart';

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

  bool isLoading = false;

  Future<void> _register() async {
    try {
      isLoading = true;
      http.Response hasil = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/users"),
        body: {
          "username": username.text,
          "password": password.text,
          "fullname": fullName.text,
          "email": email.text,
        },
      );
      final registerModel = registerModelFromJson(hasil.body);
      if (registerModel.success) {
        setState(() {
          isLoading = false;
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(registerModel.message)));
      } else {
        setState(() {
          isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          title: 'Informasi Login',
          desc: registerModel.message,
          autoHide: const Duration(seconds: 2),
        ).show();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kesalahan : ${e}")));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Center(
                  child:
                      isLoading
                          ? CircularProgressIndicator()
                          : CostumeButton(
                            bgColor: Colors.red,
                            labelButton: "SAVE",
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState!.validate()) {
                                  _register();
                                }
                              });
                            },
                            labelColor: Colors.white,
                          ),
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
