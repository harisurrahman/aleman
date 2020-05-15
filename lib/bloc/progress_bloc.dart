import 'dart:async';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/sura_model.dart';

class ProgressBloc {
  final baseUrlZip = 'https://everyayah.com/data/Abdullah_Basfar_32kbps/zips/';
  final baseUrl = 'http://www.everyayah.com/data/Abdullah_Basfar_32kbps/';

  final _progressStreamController = StreamController<double>.broadcast();
  final _suraAyesStreamController = StreamController<List<Sura>>();
  final _sidStreamController = StreamController<int>();
  final _visiblityStreamController = StreamController<bool>();
  final _suraAyasIndexStreamController = StreamController<int>();

  Stream<double> get getProgressStreamController =>
      _progressStreamController.stream;
  StreamSink<double> get getProgressSinkController =>
      _progressStreamController.sink;

  Stream<List<Sura>> get geSuraAyasStreamController =>
      _suraAyesStreamController.stream;
  StreamSink<List<Sura>> get getSuraAyasSinkController =>
      _suraAyesStreamController.sink;

  Stream<bool> get getVisibilityStreamController =>
      _visiblityStreamController.stream;
  StreamSink<bool> get getVisibilitySinkController =>
      _visiblityStreamController.sink;

  //Stream<int> get getSidStreamController => _sidStreamController.stream;
  StreamSink<int> get getSid => _sidStreamController.sink;
  StreamSink<int> get getSuraAyesAid => _suraAyasIndexStreamController;
  //StreamSink<int> get getSid => _sidStreamController.sink;

  ProgressBloc() {
    _suraAyasIndexStreamController.stream.listen(_getSuraAyas);
    _sidStreamController.stream.listen(_downloadSura);
  }

  _getSuraAyas(int path) async {
    String ayesFile = 'assets/quran/sura-${path.toString()}.json';
    String jsonString = await rootBundle.loadString(ayesFile);
    final jsonResponse = json.decode(jsonString);
    List<Sura> ayas =
        jsonResponse.map<Sura>((json) => Sura.fromJson(json)).toList();
        getSuraAyasSinkController.add(ayas);
  }

  _downloadSura(int index) async {
    Directory dir = await getApplicationDocumentsDirectory();

    Dio dio = Dio();

    bool isExists =
        await File('${dir.path}/${index.toString().padLeft(3, '0')}001.mp3')
            .exists();
    if (!isExists) {
      getVisibilitySinkController.add(true);
      //isDownload = true;
      try {
        await dio.download('$baseUrlZip${index.toString().padLeft(3, '0')}.zip',
            '${dir.path}/${index.toString().padLeft(3, '0')}.zip',
            onReceiveProgress: (rec, ttl) {
          getProgressSinkController.add((rec / ttl * 100));
        });
      } catch (err) {
        print(err);
      }
      getVisibilitySinkController.add(false);
      //isDownload = false;
      final bytes = File('${dir.path}/${index.toString().padLeft(3, '0')}.zip')
          .readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('${dir.path}/' + filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('${dir.path}/' + filename)..create(recursive: true);
          if (File('${dir.path}/${index.toString().padLeft(3, '0')}.zip')
              .existsSync()) {
            File('${dir.path}/${index.toString().padLeft(3, '0')}.zip').delete(
              recursive: true,
            );
          }
        }
      }
    }
  }

  dispose() {
    _progressStreamController.close();
    _sidStreamController.close();
    _visiblityStreamController.close();
    _suraAyesStreamController.close();
    _suraAyasIndexStreamController.close();
  }
}
