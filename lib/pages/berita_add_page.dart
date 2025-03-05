import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_berita/pages/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_berita/models/register_model.dart';

import '../utils/base_url.dart';
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

  Future<void> _uploadImage(BuildContext context) async {
    try {
      isLoading = true;
      if (_image == null) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select an image and enter text.")),
        );
        return;
      }

      final url = Uri.parse('${ApiConfig.baseUrl}/kontens');
      var request = http.MultipartRequest('POST', url);
      request.fields['judul'] = judul.text;
      request.fields['isi'] = isiBerita.text;
      request.files.add(
        await http.MultipartFile.fromPath('gambar', _image!.path),
      );
      http.StreamedResponse streamedResponse = await request.send();
      http.Response response = await http.Response.fromStream(streamedResponse);
      final uploadResponse = registerModelFromJson(response.body);
      if (uploadResponse.success) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(uploadResponse.message)));
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(uploadResponse.message)));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      logger.d("Pesan Error ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: Colors.blue,
                    // Change button color
                    foregroundColor: Colors.white, // Change text color
                  ),
                  onPressed: () {
                    setState(() {
                      if (_formKey.currentState!.validate()) {
                        _uploadImage(context);
                      }
                    });
                  },
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
