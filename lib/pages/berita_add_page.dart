import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/costume_input.dart';

class BeritaAddPage extends StatefulWidget {
  const BeritaAddPage({super.key});

  @override
  State<BeritaAddPage> createState() => _BeritaAddPageState();
}

class _BeritaAddPageState extends State<BeritaAddPage> {
  TextEditingController judul = TextEditingController();
  TextEditingController isiBerita = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  var logger = Logger();

  bool isLoading = false;

  void _alertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Silahkan dipilih?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                _getImage(ImageSource.camera);
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Camera"),
            ),
            ElevatedButton(
              onPressed: () {
                _getImage(ImageSource.gallery);
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      logger.d("Error : Picking Image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Center(
                  child: Text(
                    "Tambah Berita",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 30),
                CostumeInput(
                  label: "Judul",
                  textEditingController: judul,
                  icon: Icons.text_format,
                  textHint: "Judul Berita",
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 10),
                Text(
                  "Pilih Gambar",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    // Full width, height: 50
                    backgroundColor: Colors.red,
                    // Change button color
                    foregroundColor:
                    Colors.white, // Change text color
                  ),
                  onPressed: () => _alertDialog(context),
                  child: Text("Pilih"),
                ),
                Text(
                  "Isi Berita",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: isiBerita,
                  maxLines: 5, // Allows multiple lines
                  decoration: InputDecoration(
                    hintText: 'Enter your text here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    // Full width, height: 50
                    backgroundColor: Colors.blue,
                    // Change button color
                    foregroundColor:
                    Colors.white, // Change text color
                  ),
                  onPressed: () => null,
                  child: Text("SIMPAN"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
