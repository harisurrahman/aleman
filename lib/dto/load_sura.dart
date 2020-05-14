import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';


import '../models/sura_model.dart';

Future<String> loadSurasDetailAssets(path) async {
  return rootBundle.loadString(path);
}

Future<List<Sura>> loadSuraDetail(String path) async {
  
  String jsonString = await loadSurasDetailAssets(path);
  final jsonResponse = json.decode(jsonString);
  List<Sura> ayas =
      jsonResponse.map<Sura>((json) => Sura.fromJson(json)).toList();
  return ayas;
}


