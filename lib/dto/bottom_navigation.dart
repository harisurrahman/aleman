import 'package:flutter/material.dart';

List<BottomNavigationBarItem>bottomIcons() {
  return [
    BottomNavigationBarItem(
      icon: Icon(Icons.language),
      title: Text(
        'عربى',
        style: TextStyle(color: Colors.white, fontSize: 20.0, height: 1.2),
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.language),
      title: Text(
        'বাংলা',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.language),
      title: Text(
        'English',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    ),
  ];
}
