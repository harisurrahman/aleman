import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bookmarks.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 14),
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/quran-logo4.jpeg'),
                    ),
                  )
                ],
              ),
            )),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Bookmarks(),
              ),
            );
          },
          leading: Icon(
            Icons.bookmark,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          title: Align(
            child: new Text('Bookmarks'),
            alignment: Alignment(-1.2, 0),
          ),
        ),
        Divider(height: 2, color: Theme.of(context).primaryColor,),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Bookmarks(),
              ),
            );
          },
          leading: Icon(
            Icons.colorize,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          title: Align(
            child: new Text('Color Theme'),
            alignment: Alignment(-1.2, 0),
          ),
        ),
        Divider(height: 2, color: Theme.of(context).primaryColor,),
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Bookmarks(),
              ),
            );
          },
          leading: Icon(
            Icons.colorize,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          title: Align(
            child: new Text('Reciter'),
            alignment: Alignment(-1.2, 0),
          ),
        ),
        Divider(height: 2, color: Theme.of(context).primaryColor,),
      ],
    );
  }
}

getBookmarks() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //bookmarks.add(jsonEncode(a));
  prefs.remove('SuraIndex');
  //String bookbarks = prefs.getString('SuraIndex');
  //print(bookbarks);
}
