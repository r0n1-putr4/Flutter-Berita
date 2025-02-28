import 'package:flutter/material.dart';
import 'package:flutter_berita/utils/costume_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var username = TextEditingController();
  var password = TextEditingController();
  var fullName = TextEditingController();
  var email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    // Full width, height: 50
                    backgroundColor: Colors.red,
                    // Change button color
                    foregroundColor: Colors.white, // Change text color
                  ),
                  child: Text("SAVE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
