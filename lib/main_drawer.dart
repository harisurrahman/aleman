import 'dart:async';
import 'package:flutter/material.dart';
import 'commonFunctions.dart';
import 'sura_detail.dart';
import 'color_theme.dart';
import 'reciters.dart';

class MainDrawer extends StatefulWidget {
  MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  StreamController _streamController;
  Stream _stream;
  bool _showContent = false;
  int totalAyas = 0;
  List<Map> _bookMarks = List<Map>();

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;
    getBookMarks().then((resp) {
      if (resp != null) {
        _bookMarks.addAll(resp);
        _streamController.add(resp);
        setState(() {
          totalAyas = resp.length;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  removeBookMarkItem(int index) async {
    _bookMarks.removeAt(index);
    if (_bookMarks.length >= 0) _streamController.add(_bookMarks);
    await removeBookMark(_bookMarks);
    setState(() {
      totalAyas = _bookMarks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        InkWell(
          child: DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      width: 180,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/quran-drawer.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    )
                  ],
                ),
              )),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              onTap: () {
                setState(() {
                  if (totalAyas > 0) _showContent = !_showContent;
                });
              },
              child: Heading(
                headingText: 'Bookmark',
                iconsName: Icons.bookmark,
                ttlAyas: totalAyas,
              ),
            ),
            Visibility(
              visible: _showContent,
              child: StreamBuilder(
                stream: _stream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || snapshot.data.isEmpty) {
                    return Center(
                      child: Container(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Column(
                          children: <Widget>[
                            InkWell(
                              splashColor: Theme.of(context).primaryColor,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SuraDetail(
                                    /* data:
                                        'assets/quran/sura-${(snapshot.data[index]['sid']).toString()}.json', */
                                    name: snapshot.data[index]['name'],
                                    lang: snapshot.data[index]['lang'],
                                    index: snapshot.data[index]['sid'],
                                    ttlayas: snapshot.data[index]['ttlayas'],
                                    bookmarkAid: snapshot.data[index]['aid'],
                                  ),
                                ),
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Wrap(
                                    spacing: 2.0,
                                    textDirection:
                                        textDirection(snapshot.data[index]),
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index]['name'],
                                        style: TextStyle(
                                          fontSize: selectFontSize(
                                              snapshot.data[index]),
                                          fontWeight: selectFontWeight(
                                              snapshot.data[index]),
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage(
                                            "assets/images/ayetNo.png"),
                                        child: Text(
                                          getNumsAsLang(
                                              snapshot.data[index]['lang'],
                                              snapshot.data[index]['aid']),
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    removeBookMarkItem(index);
                                  },
                                ),
                              ),
                            ),
                            Divider(
                              height: 0.2,
                              color: Theme.of(context).primaryColor,
                              indent: 30,
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ColorThemes())),
              child: Heading(
                headingText: 'Theme Color',
                iconsName: Icons.colorize,
                ttlAyas: 0,
              ),
            ),
            InkWell(
               onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Reciter())),
              child: Heading(
                headingText: 'Reciter',
                iconsName: Icons.supervised_user_circle,
                ttlAyas: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Heading extends StatefulWidget {
  final String headingText;
  final IconData iconsName;
  final int ttlAyas;
  Heading({Key key, this.headingText, this.iconsName, this.ttlAyas})
      : super(key: key);

  @override
  _HeadingState createState() => _HeadingState();
}

class _HeadingState extends State<Heading> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            widget.iconsName,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          title: Align(
            child: new Text(widget.headingText),
            alignment: Alignment(-1.2, 0),
          ),
          trailing: (widget.ttlAyas > 0)
              ? Badge(
                  totalAyas: widget.ttlAyas.toString(),
                )
              : null,
        ),
        Divider(
          height: 2,
          color: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}

class Badge extends StatelessWidget {
  final String totalAyas;
  const Badge({Key key, this.totalAyas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: 44.0,
        height: 30.0,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Center(
          child: Text(
            totalAyas,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
