import 'package:flutter/material.dart';
import 'package:flutter_berita/utils/costume_button.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5CB58),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("images/gambar_satu.png"),
              SizedBox(height: 15,),
              CostumeButton(
                bgColor: Color(0xffF3E9B5),
                labelButton: "Mulai",
                onPressed: () {},
                labelColor: Color(0xffE95322),
                sizeButton: 0.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
