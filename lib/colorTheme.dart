import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<Color> colors = [
  null,
  Colors.indigo,
  Color(0xff0a5106),
  Colors.pink,
  Colors.amber[300],
  Colors.yellow[200]
];



/* Future<String> _getColorThme() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  return _pref.getInt('currentTheme');
} */

Future<ThemeColor> getColorTheme() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  int colorIndex = _pref.getInt('currentTheme');
  ThemeColor theme = ThemeColor(colors[colorIndex], colorIndex);
  return theme;
}

Future<ThemeColor> setColorTheme(int colorIndex) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  ThemeColor theme = ThemeColor(colors[colorIndex], colorIndex);
  await _pref.setInt('currentTheme', colorIndex);
  return theme;
}

class ThemeColor{
  final Color color;
  final int index;

  ThemeColor(this.color, this.index);

  Color get getColor{
    return this.color;
  }

  int get colorIndex{
    return index;
  }
}

