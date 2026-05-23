import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_berita/providers/berita_provider.dart';
import 'package:flutter_berita/utils/session.dart';
import 'package:flutter_berita/models/berita_model.dart';
import 'package:logger/logger.dart';
import 'dart:async';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utils/base_url.dart';
import 'item_berita_page.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var logger = Logger();
  String judul = "";
  TextEditingController judulController = TextEditingController();

  String username = "";
  String fullname = "";
  String email = "";
  String gambar = "";

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
    Future.microtask(() => context.read<BeritaProvider>().getBerita(""));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BeritaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: TextField(
          controller: judulController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          onSubmitted: (value) {
            context.read<BeritaProvider>().getBerita(value);
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
                backgroundImage: NetworkImage(gambar, scale: 1.0),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () {
                null;
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {},
            ),
          ],
        ),
      ),
      body:
          provider.isLoading
              ? Center(child: CircularProgressIndicator())
              : provider.berita.isEmpty
              ? Center(child: Text("Tidak ada data"))
              : ListView.builder(
                itemCount: provider.berita.length,
                itemBuilder: (context, index) {
                  Datum beritaItem = provider.berita[index];
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItemBeritaPage(beritaItem),
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
                                            'Apakah anda yakin ingin hapus ${beritaItem.judul}?',
                                        buttonsTextStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        showCloseIcon: true,
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: ()  async {
                                         String hasildel = await provider.deleteBerita(beritaItem.id);

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(content: Text(hasildel)),
                                          );
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
                                "${ApiConfig.baseUrl}/kontens/gambar?filename=${beritaItem.gambar}",
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
                                      beritaItem.judul,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 12),
                                      softWrap: true, // Ensures text wraps
                                      overflow:
                                          TextOverflow
                                              .visible, // Ensures text is shown fully
                                    ),
                                    Text(
                                      beritaItem.tgl_berita,
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
                                          rating: beritaItem.rating,
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
