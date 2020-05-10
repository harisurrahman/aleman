import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
//import 'colorTheme.dart';


StreamController<int> _streamController;
Stream stream;

getColorThemeStream(SharedPreferences _pref) {
  _streamController = StreamController<int>();
  stream = _streamController.stream;
  int colorIndex = _pref.getInt('currentTheme');

  //ThemeColor theme = ThemeColor(colors[colorIndex], colorIndex);
  _streamController.add(colorIndex);
  
}