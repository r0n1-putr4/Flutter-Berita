import 'package:flutter/material.dart';
import 'package:flutter_berita/utils/costume_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var username = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            child: Column(
              children: [
                SizedBox(height: 30,),
                Text("Register",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                CostumeInput(
                  label: "Userame",
                  textEditingController: username,
                  icon: Icons.person,
                  textHint: "r0n1",
                  textInputType: TextInputType.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
