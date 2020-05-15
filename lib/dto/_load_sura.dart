import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';


import '../models/sura_model.dart';

Future<String> loadSurasDetailAssets(path) async {
  //String ayesFile = 'assets/quran/sura-${path.toString().padLeft(3)}.json';
  return rootBundle.loadString(path);
}

Future<List<Sura>> loadSuraDetail(int path) async {
  String ayesFile = 'assets/quran/sura-${path.toString()}.json';
  String jsonString = await loadSurasDetailAssets(ayesFile);
  final jsonResponse = json.decode(jsonString);
  List<Sura> ayas =
      jsonResponse.map<Sura>((json) => Sura.fromJson(json)).toList();
  return ayas;
}


