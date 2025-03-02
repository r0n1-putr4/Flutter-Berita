import 'package:awesome_dialog/awesome_dialog.dart'
    show AnimType, AwesomeDialog, DialogType;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/pages/home_page.dart';
import 'package:flutter_berita/pages/register_page.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import '../utils/base_url.dart';
import '../utils/costume_input.dart';
import '../utils/session.dart';
import 'package:flutter_berita/models/login_model.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _login() async {
    try {
      isLoading = true;
      http.Response hasil = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/login.php"),
        body: {"username": username.text, "password": password.text},
      );
      final loginModel = loginModelFromJson(hasil.body);
      if (loginModel.success) {
        setState(() {
          isLoading = false;
        });
        final dataUser = loginModel.data;
        await SessionManager.saveSession(
          dataUser!.id,
          dataUser.username,
          dataUser.fullname,
          dataUser.email
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          isLoading = false;
        });
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          title: 'Informasi Login',
          desc: loginModel.message,
          autoHide: const Duration(seconds: 2),
        ).show();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      logger.d("Kesalahan ${e}");
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
                Center(
                  child:
                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              // Full width, height: 50
                              backgroundColor: Colors.red,
                              // Change button color
                              foregroundColor:
                                  Colors.white, // Change text color
                            ),
                            onPressed: () {
                              setState(() {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              });
                            },
                            child: Text(
                              "LOGIN",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
