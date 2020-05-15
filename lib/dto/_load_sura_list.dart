import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/sura_list_model.dart';

Future<String> loadSurasFromAssets() async {
  return rootBundle.loadString('assets/json/sura-list.json');
}

Future loadSuraList() async {
  String jsonString = await loadSurasFromAssets();
  final jsonResponse = json.decode(jsonString);
  List<SuraList> suras =
      jsonResponse.map<SuraList>((json) => SuraList.fromJson(json)).toList();
  return suras;
}


