import 'package:shared_preferences/shared_preferences.dart';

Future<int> getColorTheme() async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  int colorIndex = _pref.getInt('currentTheme');
  return colorIndex;
}

setColorTheme(int colorIndex) async {
  SharedPreferences _pref = await SharedPreferences.getInstance();
  _pref.setInt('currentTheme', colorIndex);
  
}



