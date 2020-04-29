import 'dart:convert';
import 'package:persian/persian.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookmarks extends StatefulWidget {
  Bookmarks({Key key}) : super(key: key);

  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  Future<List<Map>> getBookMarks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String bookmarks = pref.getString('bookmarks');
    var jsonResp = await json.decode(bookmarks);
    List<Map> listOfBookmarks = List<Map>();
    await jsonResp.forEach((bookmark) async {
      listOfBookmarks.add(bookmark);
    });

    return listOfBookmarks;
  }

  String setBookmarkAyet(int aid, String lang) {
    String ayet;
    switch (lang) {
      case 'original':
        ayet = aid.toString().withPersianNumbers();
        break;
      case 'bangla':
        ayet = aid.toString().withBanglaNumbers();
        break;
      default: ayet = aid.toString();
    }
    return ayet;
  }

  @override
  void initState() {
    super.initState();
    getBookMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bookmarks'),
        ),
        body: Container(
          child: FutureBuilder(
            future: getBookMarks(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      /*  */
                      return Column(
                        children: <Widget>[
                          ListTile(
                            trailing: Icon(
                              Icons.delete,
                              color: Theme.of(context).primaryColor,
                              size: 35,
                            ),
                            title: Wrap(
                              textDirection:
                                  snapshot.data[index]['lang'] == 'original'
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                              children: <Widget>[
                                Text(
                                  snapshot.data[index]['name'],
                                  style: TextStyle(fontSize: 25),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        AssetImage("assets/images/avator.png"),
                                    child: Text(
                                      setBookmarkAyet(snapshot.data[index]['aid'], snapshot.data[index]['lang']),
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            /* title: Text(snapshot.data[index]['name'], textDirection: TextDirection.rtl, style: TextStyle(fontSize: 25),), */
                          ),
                          Divider(height: 1, color: Theme.of(context).primaryColor,)
                        ],
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}
