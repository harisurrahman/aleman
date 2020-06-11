import 'dart:convert';
import 'dart:io';
import 'package:persian/persian.dart';
import 'number_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'reciters.dart';
import 'package:path_provider/path_provider.dart';

String getNumsAsLang(lang, index) {
  switch (lang) {
    case 'bangla':
      return index.toString().withBanglaNumbers();
    case 'original':
      return index.toString().withPersianNumbers();
    default:
      return index.toString();
  }
}

double selectFontSize(Map snapshot) {
  return (snapshot['lang'] == 'original') ? 23 : 20;
}

FontWeight selectFontWeight(Map snapshot) {
  return (snapshot['lang'] == 'original') ? FontWeight.w500 : FontWeight.normal;
}

TextDirection textDirection(Map snapshot) {
  return snapshot['lang'] == 'original' ? TextDirection.rtl : TextDirection.ltr;
}

Future<List<Map>> getBookMarks() async {
  List<Map> listOfBookmarks = List<Map>();
  SharedPreferences pref = await SharedPreferences.getInstance();
  String bookmarks = pref.getString('bookmarks');
  if (bookmarks != null) {
    var jsonResp = await json.decode(bookmarks);
    await jsonResp.forEach((bookmark) async {
      listOfBookmarks.add(bookmark);
    });
  }

  return listOfBookmarks;
}

removeBookMark(List<Map> bookmarks) async {
  String bookmarkString = json.encode(bookmarks);
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('bookmarks', bookmarkString);
}

void writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  File(path)..createSync(recursive: true)..writeAsBytesSync((buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)));
}

copyFromAssets() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String path = (await getApplicationDocumentsDirectory()).path;
  if (_pref.getInt('first_run') == null) {
    String name = '';
    var bytes;

     for(var reciter in reciters){

      name = reciter['name'].replaceAll(' ', '-');
      try{
        bytes = await rootBundle.load('assets/bismillah/$name/001001.mp3');
        writeToFile(bytes, '$path/$name/001001.mp3');
      }catch(err){
        print(err);
      }finally{
        _pref.setInt('first_run', 1);
      }

    }
  }
}

Future<int>getAuther()async{
  SharedPreferences _pref = await SharedPreferences.getInstance();
  int auther = _pref.getInt('auther');
  if(auther==null){
    auther = 0;
    _pref.setInt('auther', auther);
  }
  return auther;

}

setAuther(int auther)async{
  SharedPreferences _pref = await SharedPreferences.getInstance();
  _pref.setInt('auther', auther);
 

}
