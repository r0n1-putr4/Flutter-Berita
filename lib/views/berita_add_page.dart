import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_berita/providers/berita_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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

  final _formKey = GlobalKey<FormState>();

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
    final provider = context.watch<BeritaProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
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
                SizedBox(height: 15),
                Text(
                  "Pilih Gambar",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    // Full width, height: 50
                    backgroundColor: Colors.red,
                    // Change button color
                    foregroundColor: Colors.white, // Change text color
                  ),
                  onPressed: () => _alertDialog(context),
                  child: Text("Pilih"),
                ),
                SizedBox(height: 5),
                _image != null
                    ? Center(child: Image.file(_image!, height: 200))
                    : Text("No image selected"),
                SizedBox(height: 15),
                Text(
                  "Isi Berita",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: isiBerita,

                  maxLines: 5, // Allows multiple lines
                  decoration: InputDecoration(
                    hintText: 'Enter your text here...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    return val!.isEmpty ? "Tidak boleh kosong" : null;
                  },
                ),
                SizedBox(height: 15),
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
                              if (_image == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Pilih gambar terlebih dahulu",
                                    ),
                                  ),
                                );
                                return;
                              }

                              String pesan = await context
                                  .read<BeritaProvider>()
                                  .addBerita(
                                    judul.text,
                                    isiBerita.text,
                                    _image!,
                                  );

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text("$pesan")));

                              if(provider.success){
                                Navigator.pushNamed(context, "/home");
                              }
                            }
                          },
                  child:
                      provider.isLoading
                          ? CircularProgressIndicator()
                          : Text("SAVE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
