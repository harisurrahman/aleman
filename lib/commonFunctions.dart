import 'dart:convert';
import 'package:persian/persian.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

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
