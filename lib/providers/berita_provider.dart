import 'package:flutter/material.dart';
import 'package:flutter_berita/models/berita_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../utils/base_url.dart';

class BeritaProvider extends ChangeNotifier {
  List<Datum> _data = [];

  List<Datum> get berita => _data;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _message = "";

  String get message => _message;

  Future<void> getBerita(String judul) async {
    try {
      _isLoading = true;
      notifyListeners();
      http.Response hasil = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/kontens?judul=${judul}"),
        headers: {},
      );

      final _hasil = beritaModelFromJson(hasil.body);

      _data = _hasil.data ?? [];

      _message = "Success";

    } catch (e) {
      _message = "Error : $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
