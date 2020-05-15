import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/sura_list_model.dart';

class SuraListBloc {
  final _suraListStreamController = StreamController<List<SuraList>>();

  Stream<List<SuraList>> get getSuraListStream =>
      _suraListStreamController.stream;

  dispose() {
    _suraListStreamController.close();
  }

  SuraListBloc() {
    _getSuraList().then(
        (suraList) => {_suraListStreamController.add(suraList)});
  }

  _getSuraList() async {
    String jsonString =
        await rootBundle.loadString('assets/json/sura-list.json');
    final jsonResponse = json.decode(jsonString);
    List<SuraList> suras = await jsonResponse
        .map<SuraList>((json) => SuraList.fromJson(json))
        .toList();
    return suras;
  }
}
