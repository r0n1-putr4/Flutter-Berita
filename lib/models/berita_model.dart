// To parse this JSON data, do
//
//     final beritaModel = beritaModelFromJson(jsonString);

import 'dart:convert';

BeritaModel beritaModelFromJson(String str) => BeritaModel.fromJson(json.decode(str));

String beritaModelToJson(BeritaModel data) => json.encode(data.toJson());

class BeritaModel {
  bool success;
  String message;
  List<Datum> data;

  BeritaModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) => BeritaModel(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String judul;
  String isi;
  String gambar;
  String tgl_berita;
  double rating;

  Datum({
    required this.id,
    required this.judul,
    required this.isi,
    required this.gambar,
    required this.tgl_berita,
    required this.rating,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"], // Default 0 for integers
    judul: json["judul"], // Default empty string
    isi: json["isi"] ,
    gambar: json["gambar"],
    tgl_berita: json["tgl_berita"],
    rating: json["rating"].toDouble(), // Default 0.0
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "judul": judul,
    "isi": isi,
    "gambar": gambar,
    "tgl_berita": tgl_berita,
    "rating": rating,
  };
}
