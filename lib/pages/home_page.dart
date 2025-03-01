import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/utils/session.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(sessionManager.is_login==null){
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.info,
        body: Center(child: Text(
          'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
        title: 'This is Ignored',
        desc:   'This is also Ignored',
        btnOkOnPress: () {},
      ).show();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
