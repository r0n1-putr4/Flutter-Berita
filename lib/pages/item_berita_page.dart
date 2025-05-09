import 'package:flutter/material.dart';
import 'package:flutter_berita/models/berita_model.dart';
import 'package:flutter_berita/utils/base_url.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemBeritaPage extends StatelessWidget {
  final Datum itemDataBerita;

  const ItemBeritaPage(this.itemDataBerita, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Berita")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: NetworkImage(
                  "${ApiConfig.baseUrl}/${itemDataBerita.gambar}",
                ),
              ),
              Text(
                itemDataBerita.judul,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(itemDataBerita.tgl_berita, style: TextStyle(fontSize: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RatingBarIndicator(
                    rating: itemDataBerita.rating,
                    itemBuilder:
                        (context, index) =>
                            Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 15,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
              Text(
                itemDataBerita.isi,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
