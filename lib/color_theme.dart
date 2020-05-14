import 'package:aleman/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'colorTheme.dart';
//import 'themeStream.dart';

class ColorThemes extends StatefulWidget {
  @override
  _ColorThemesState createState() => _ColorThemesState();
}

class _ColorThemesState extends State<ColorThemes> {
  int _selectedRadio = 1;
  @override
  void initState() {
    getColorTheme().then((theme) {
      setState(() {
        _selectedRadio = theme;
      });
    });
    super.initState();
  }


  _setColorState(int selectedTheme) async {
    setState(() {
      _selectedRadio = selectedTheme;
    });
    await setColorTheme(selectedTheme);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Schemes'),
        /* backgroundColor: _currentTheme, */
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: pallets.length,
          itemBuilder: (BuildContext ctx, int index) => Card(
            child: InkWell(
              onTap: () {
                _setColorState(pallets[index]['index']);
                theme.setTheme(themes[pallets[index]['index']]);
              },
              child: ListTile(
                title: Text(pallets[index]['title']),
                trailing: Radio(
                    activeColor: pallets[index]['color'],
                    value: pallets[index]['index'],
                    groupValue: _selectedRadio,
                    onChanged: (val) {
                      _setColorState(val);
                      theme.setTheme(themes[val]);
                    }),
                leading: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: pallets[index]['color'],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
