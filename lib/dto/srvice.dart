import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

String progress = '';
  Future<void> downloadFile() async {
    Directory dir = await getApplicationDocumentsDirectory();
    for (int i = 1; i <= 286; i++) {
      String sura =
      'http://www.everyayah.com/data/Abdul_Basit_Murattal_192kbps/002${i.toString().padLeft(3,'0')}.mp3';
      print('${i.toString().padLeft(3,'0')}');
      bool isExists = await File('${dir.path}/002${i.toString().padLeft(3,'0')}.mp3').exists();
      if (!isExists) {
        Dio dio = Dio();

        await dio.download(sura, '${dir.path}/002${i.toString().padLeft(3,'0')}.mp3',
            onReceiveProgress: (rec, ttl) {
          /* print(rec);
          setState(() {
            progress = 'Progress : $i of 285';
          }); */
        });
      }
    }
  }