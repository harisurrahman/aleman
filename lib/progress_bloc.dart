import 'dart:async';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class ProgressBloc {

  bool isDownload = false;
  String progress = '0';
  double parsentage = 0;
  final baseUrlZip = 'https://everyayah.com/data/Abdullah_Basfar_32kbps/zips/';
  final baseUrl = 'http://www.everyayah.com/data/Abdullah_Basfar_32kbps/';

  final _progressStreamController = StreamController<double>.broadcast();
  final _sidStreamController = StreamController<int>();
  final _visiblityStreamController = StreamController<bool>();

  Stream<double> get getProgressStreamController => _progressStreamController.stream;
  StreamSink<double> get getProgressSinkController => _progressStreamController.sink;

  Stream<bool> get getVisibilityStreamController => _visiblityStreamController.stream;
  StreamSink<bool> get getVisibilitySinkController => _visiblityStreamController.sink;  

  //Stream<int> get getSidStreamController => _sidStreamController.stream;
  StreamSink<int> get getSid => _sidStreamController.sink;

  


  ProgressBloc() {
   /*  _downloadSura(index); */
    _sidStreamController.stream.listen(_downloadSura);     
  }

  _downloadSura(int index)async{
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
          /* setState(() {
            progress = (rec / ttl * 100).toStringAsFixed(0);
            parsentage = (rec / ttl * 100) / 100;
          }); */
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
  }
}
