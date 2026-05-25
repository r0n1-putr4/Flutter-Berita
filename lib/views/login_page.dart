import 'package:awesome_dialog/awesome_dialog.dart'
    show AnimType, AwesomeDialog, DialogType;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/utils/costume_button.dart';
import 'package:flutter_berita/views/register_page.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/login_model.dart';
import '../providers/user_provider.dart';
import '../utils/base_url.dart';
import '../utils/costume_input.dart';
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
  bool isLoading = false;
  var logger = Logger();

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25),
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
                                  .login(username.text, password.text);

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text("$pesan")));

                              if (provider.success) {
                                await SessionManager.saveSession(
                                  provider.user!.id,
                                  provider.user!.username,
                                  provider.user!.fullname,
                                  provider.user!.email,
                                  provider.user!.gambar,
                                );
                                Navigator.pushNamed(context, "/home");
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
