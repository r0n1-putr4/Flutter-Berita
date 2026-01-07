// To parse this JSON data, do
//
//     final responseModelLogin = responseModelLoginFromJson(jsonString);

import 'dart:convert';

ResponseModelLogin responseModelLoginFromJson(String str) => ResponseModelLogin.fromJson(json.decode(str));

String responseModelLoginToJson(ResponseModelLogin data) => json.encode(data.toJson());

class ResponseModelLogin {
  bool success;
  String message;
  Data? data;

  ResponseModelLogin({
    required this.success,
    required this.message,
    this.data,
  });

  factory ResponseModelLogin.fromJson(Map<String, dynamic> json) => ResponseModelLogin(
    success: json["success"],
    message: json["message"],
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    if(data != null)  "data" : data!.toJson(),
  };
}

class Data {
  int id;
  String email;
  String nama;
  String noHp;
  String password;
  String alamat;

  Data({
    required this.id,
    required this.email,
    required this.nama,
    required this.noHp,
    required this.password,
    required this.alamat,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    email: json["email"],
    nama: json["nama"],
    noHp: json["no_hp"],
    password: json["password"],
    alamat: json["alamat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "nama": nama,
    "no_hp": noHp,
    "password": password,
    "alamat": alamat,
  };
}
