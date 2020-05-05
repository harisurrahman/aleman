import 'dart:async';

import 'package:flutter/material.dart';
import 'commonFunctions.dart';

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

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;
    getBookMarks().then((resp) {
      _streamController.add(resp);
      setState(() {
        totalAyas = resp.length;
      });
    });
    super.initState();
  }

  removeBookMarkItem(int index) async {
    List<Map> resp = await getBookMarks();
    resp.removeAt(index);
    await removeBookMark(resp);
    _streamController.add(resp);

    setState(() {
      totalAyas = resp.length;
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
                  _showContent = !_showContent;
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
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext ctx, int index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Wrap(
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage(
                                            "assets/images/ayetNo.png"),
                                        child: Text(getNumsAsLang(
                                            context, snapshot, index)),
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
                            Divider(
                              height: 2,
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
            Heading(
              headingText: 'Theme Color',
              iconsName: Icons.colorize,
              ttlAyas: 0,
            ),
            Heading(
              headingText: 'Preferences',
              iconsName: Icons.settings,
              ttlAyas: 0,
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
          trailing: Badge(
            totalAyas: widget.ttlAyas.toString(),
          ),
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
