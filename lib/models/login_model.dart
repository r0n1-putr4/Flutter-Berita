// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool success;
  String message;
  Data? data;

  LoginModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    success: json["success"],
    message: json["message"],
    data: (json["data"] != null && json["data"] is Map<String, dynamic>)
        ? Data.fromJson(json["data"])
        : null, // ✅ Handle jika `data` kosong atau bukan object
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(), // ✅ Handle `null` dengan `?.`
  };
}

class Data {
  String id;
  String username;
  String fullname;

  Data({
    required this.id,
    required this.username,
    required this.fullname,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    fullname: json["fullname"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "fullname": fullname,
  };
}
