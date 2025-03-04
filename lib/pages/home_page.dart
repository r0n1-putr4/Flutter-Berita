import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/pages/item_berita_page.dart';
import 'package:flutter_berita/utils/session.dart';
import 'package:flutter_berita/models/berita_model.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_berita/models/response_model.dart';

import '../utils/base_url.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Datum>?> dataJson;
  var logger = Logger();
  String judul = "";
  TextEditingController judulController = TextEditingController();

  String username = "";
  String fullname = "";
  String email = "";
  String gambar = "";

  Future<List<Datum>?> _getData(String judul) async {
    try {
      http.Response hasil = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/kontens?judul=${judul}"),
      );
      logger.d("Status ${beritaModelFromJson(hasil.body).success}");
      print("Status ${beritaModelFromJson(hasil.body).success}");
      return beritaModelFromJson(hasil.body).data;
    } catch (e) {
      print("Kesalahan ${e}");
      logger.d("Kesalahan ${e} ${ApiConfig.baseUrl}/kontens?judul=${judul}");
    }
    return null;
  }

  Future<void> _delBerita(int id) async {
    try {
      http.Response hasil = await http.delete(
        Uri.parse("${ApiConfig.baseUrl}/kontens/$id")
      );
      final deleteModel = responseModelFromJson(hasil.body);
      if (deleteModel.success) {
        setState(() {
          dataJson = _getData(judul);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(deleteModel.message)));
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.scale,
          title: 'Informasi Delete',
          desc: deleteModel.message,
          autoHide: const Duration(seconds: 2),
        ).show();
      }
    } catch (e) {
      logger.d("Kesalahan delete $e");
    }
  }

  void _logout() async {
    await SessionManager.clearSession();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _loadSession() async {
    Map<String, dynamic> session = await SessionManager.getSession();
    setState(() {
      username = session['username']!;
      fullname = session['fullname']!;
      email = session['email']!;
      gambar = session['gambar']!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSession();
    dataJson = _getData(judul);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextField(
          controller: judulController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onSubmitted: (value) {
            setState(() {
              dataJson = _getData(value);
            });
          },
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            hintText: "Search...",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                headerAnimationLoop: false,
                animType: AnimType.bottomSlide,
                title: 'Logout',
                desc: 'Apakah anda yakin ingin keluar?',
                buttonsTextStyle: const TextStyle(color: Colors.white),
                showCloseIcon: true,
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  _logout();
                },
              ).show();
            },
          ),
        ],
      ),
      drawer: Drawer(
        // backgroundColor: Colors.white,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue, // Header background color
              ),
              accountName: Text(fullname),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                radius: 50, // Adjust size
                backgroundColor: Colors.white, // Optional: Background color
                backgroundImage: NetworkImage(
                  "${ApiConfig.baseUrl}/images/$gambar",
                ),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () {
                null;
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Datum>?>(
        future: dataJson,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan saat mengambil data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Tidak ada data berita"));
          } else {
            List<Datum> berita = snapshot.data!;
            return ListView.builder(
              itemCount: berita.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemBeritaPage(berita[index]),
                        ),
                      );
                    },
                    child: Slidable(
                      // Specify a key if the Slidable is dismissible.
                      key: ValueKey(0),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: ScrollMotion(),

                        children: [
                          // A SlidableAction can have an icon and/or a label.
                          SlidableAction(
                            onPressed:
                                (_) =>
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      headerAnimationLoop: false,
                                      animType: AnimType.bottomSlide,
                                      title: 'Delete',
                                      desc:
                                          'Apakah anda yakin ingin hapus ${berita[index].judul}?',
                                      buttonsTextStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      showCloseIcon: true,
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        _delBerita(berita[index].id);
                                      },
                                    ).show(),
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ],
                      ),

                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Aligns text to the top
                          children: [
                            Image.network(
                              "${ApiConfig.baseUrl}/${berita[index].gambar}",
                              width: 80, // Adjust width
                              height: 80, // Adjust height
                              fit: BoxFit.cover,
                              alignment: Alignment.topLeft,
                            ),
                            SizedBox(width: 10),
                            // Space between image and text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    berita[index].judul,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 24),
                                    softWrap: true, // Ensures text wraps
                                    overflow:
                                        TextOverflow
                                            .visible, // Ensures text is shown fully
                                  ),
                                  Text(
                                    berita[index].tgl_berita,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RatingBarIndicator(
                                        rating: berita[index].rating,
                                        itemBuilder:
                                            (context, index) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        itemCount: 5,
                                        itemSize: 15,
                                        direction: Axis.horizontal,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, size: 30, color: Colors.white),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/addBerita');
        },
      ),
    );
  }
}
