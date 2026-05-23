import 'package:flutter/material.dart';
import 'package:flutter_berita/models/berita_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

import '../models/response_model.dart';
import '../utils/base_url.dart';

class BeritaProvider extends ChangeNotifier {
  List<Datum> _data = [];
  List<Datum> get berita => _data;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = "";
  String get message => _message;

  bool _success = false;
  bool get success => _success;

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

  Future<String> deleteBerita(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("${ApiConfig.baseUrl}/kontens/$id"),
      );

      final hasilDelete = responseModelFromJson(response.body);

      if (hasilDelete.success) {
        berita.removeWhere((item) => item.id == id);

        notifyListeners();
      }

      return hasilDelete.message;
    } catch (e) {
      return "Error : $e";
    }
  }

  Future<String> addBerita(String judul, String isi, File image) async {
    try {
      _isLoading = true;
      notifyListeners();

      final url = Uri.parse("${ApiConfig.baseUrl}/kontens");

      var request = http.MultipartRequest('POST', url);

      request.fields['judul'] = judul;

      request.fields['isi'] = isi;

      request.files.add(
        await http.MultipartFile.fromPath('gambar', image.path),
      );

      http.StreamedResponse streamedResponse = await request.send();

      http.Response response = await http.Response.fromStream(streamedResponse);

      final hasil = responseModelFromJson(response.body);

      _success = hasil.success;

      return hasil.message;

    } catch (e) {
      return _message = "Error : $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
