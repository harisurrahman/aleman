import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger extends ChangeNotifier {
  ThemeData _themeData;
  SharedPreferences _pref;

  ThemeChanger(this._themeData) {
    _themeData = themes[1];
    _loadFromPref();
  }

  ThemeData getTheme() {
    return _themeData;
  }

  setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  _initPref() async {
    if (_pref == null) {
      _pref = await SharedPreferences.getInstance();
    }
  }

  _loadFromPref() async {
    await _initPref();
    int _themeIndex = _pref.getInt('currentTheme');
    _themeData = themes[_themeIndex ?? 1];
    notifyListeners();
  }
}

List<Map<String, dynamic>> pallets = [
  {"index": 1, "color": Color(0xFF311B92), 'title': 'Indigo'},
  {"index": 2, "color": Color(0xff0a5106), 'title': 'Green'},
  {"index": 3, "color": Color(0xFF880E4F), 'title': 'Magenta'},
  {"index": 4, "color": Color(0xFFEC407A), 'title': 'Pink'},
  {"index": 5, "color": Color(0xFFFFB74D), 'title': 'Amber'},
  {"index": 6, "color": Color(0xFF3E2723), 'title': 'Brown'},
  {"index": 7, "color": Color(0xFF8F3985), 'title': 'Purple'},
];

const List<MaterialColor> primaryColorShades = [
  MaterialColor(
    /*Null*/
    0xFFA4A4BF,
    <int, Color>{
      50: Color(0xFFA4A4BF),
      100: Color(0xFFA4A4BF),
      200: Color(0xFFA4A4BF),
      300: Color(0xFF9191B3),
      400: Color(0xFF7F7FA6),
      500: Color(0xFF7F7FA6),
      600: Color(0xFF6D6D99),
      700: Color(0xFF5B5B8D),
      800: Color(0xFF494980),
      900: Color(0xFF181861),
    },
  ),
  MaterialColor(
    0xFF311B92,
    /*Indigo*/
    <int, Color>{
      50: Color(0xFF311B92),
      100: Color(0xFF311B92),
      200: Color(0xFF311B92),
      300: Color(0xFF311B92),
      400: Color(0xFF311B92),
      500: Color(0xFF311B92),
      600: Color(0xFF311B92),
      700: Color(0xFF311B92),
      800: Color(0xFF311B92),
      900: Color(0xFF311B92),
    },
  ),
  MaterialColor(
    0xff0a5106,
    /*Green */
    <int, Color>{
      50: Color(0xff0a5106),
      100: Color(0xff0a5106),
      200: Color(0xff0a5106),
      300: Color(0xff0a5106),
      400: Color(0xff0a5106),
      500: Color(0xff0a5106),
      600: Color(0xff0a5106),
      700: Color(0xff0a5106),
      800: Color(0xff0a5106),
      900: Color(0xff0a5106),
    },
  ),
  MaterialColor(
    0xFF880E4F,
    /*Magenta*/
    <int, Color>{
      50: Color(0xFF880E4F),
      100: Color(0xFF880E4F),
      200: Color(0xFF880E4F),
      300: Color(0xFF880E4F),
      400: Color(0xFF880E4F),
      500: Color(0xFF880E4F),
      600: Color(0xFF880E4F),
      700: Color(0xFF880E4F),
      800: Color(0xFF880E4F),
      900: Color(0xFF880E4F),
    },
  ),
  MaterialColor(
    0xFFEC407A,
    /**Brown */
    <int, Color>{
      50: Color(0xFFEC407A),
      100: Color(0xFFEC407A),
      200: Color(0xFFEC407A),
      300: Color(0xFFEC407A),
      400: Color(0xFFEC407A),
      500: Color(0xFFEC407A),
      600: Color(0xFFEC407A),
      700: Color(0xFFEC407A),
      800: Color(0xFFEC407A),
      900: Color(0xFFEC407A),
    },
  ),
  MaterialColor(
    0xFFFFB74D,
    /**Amber */
    <int, Color>{
      50: Color(0xFFFFCA28),
      100: Color(0xFFFFCA28),
      200: Color(0xFFFFCA28),
      300: Color(0xFFFFCA28),
      400: Color(0xFFFFCA28),
      500: Color(0xFFFFCA28),
      600: Color(0xFFFFCA28),
      700: Color(0xFFFFCA28),
      800: Color(0xFFFFCA28),
      900: Color(0xFFFFCA28),
    },
  ),
  MaterialColor(
    0xFF3E2723,
    /**Brown */
    <int, Color>{
      50: Color(0xFF3E2723),
      100: Color(0xFF3E2723),
      200: Color(0xFF3E2723),
      300: Color(0xFF3E2723),
      400: Color(0xFF3E2723),
      500: Color(0xFF3E2723),
      600: Color(0xFF3E2723),
      700: Color(0xFF3E2723),
      800: Color(0xFF3E2723),
      900: Color(0xFF3E2723),
    },
  ),
  MaterialColor(
    0xFF8F3985,
    /**Purple */
    <int, Color>{
      50: Color(0xFF8F3985),
      100: Color(0xFF8F3985),
      200: Color(0xFF8F3985),
      300: Color(0xFF8F3985),
      400: Color(0xFF8F3985),
      500: Color(0xFF8F3985),
      600: Color(0xFF8F3985),
      700: Color(0xFF8F3985),
      800: Color(0xFF8F3985),
      900: Color(0xFF8F3985),
    },
  ),
];

List<ThemeData> themes = [
  ThemeData(
    primarySwatch: primaryColorShades[0],
  ),
  ThemeData(
    primarySwatch: primaryColorShades[1],
  ),
  ThemeData(
    primarySwatch: primaryColorShades[2],
  ),
  ThemeData(
    primarySwatch: primaryColorShades[3],
  ),
  ThemeData(
    primarySwatch: primaryColorShades[4],
  ),
  ThemeData(
    primarySwatch: primaryColorShades[5],
  ),
  ThemeData(
    primarySwatch: primaryColorShades[6],
  ),
  ThemeData(
    primarySwatch: primaryColorShades[7],
  ),
];
