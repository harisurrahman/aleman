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
  bool _showContent = false;
  bool _translated = false;
  int totalAyas = 0;
  List<Map> _bookMarks = List<Map>();
  List<bool> _auther = List<bool>.filled(2, false);

  @override
  void initState() {
    getBookMarks().then((resp) {
      if (resp != null) {
        _bookMarks.addAll(resp);
        setState(() {
          totalAyas = _bookMarks.length;
        });
      }
    });

    getAuther().then((translator){
      setState(() {
        _auther[translator] = true;
      });
    });

    
    
    super.initState();
  }

  _setAuther(int auther){
      _auther[0] = false;
      _auther[1] = false;
      setState(() {
        _auther[auther] = true;
      });
      setAuther(auther);
    }

  populateBookmark() async {
    return _bookMarks;
  }

  @override
  void dispose() {
    super.dispose();
  }

  removeBookMarkItem(int index) async {
    _bookMarks.removeAt(index);
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
        DrawerHeader(
              
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/quran-drawer12.png'),
                  fit: BoxFit.fill,
                ),)
              )),
      
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              splashColor: Theme.of(context).primaryColor,
              onTap: () {
                //_streamController.add(resp);
                setState(() {
                  if (totalAyas > 0) {
                    _showContent = !_showContent;
                    if (_showContent) {
                      populateBookmark();
                    }
                  }
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
              child: FutureBuilder(
                future: populateBookmark(),
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
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SuraDetail(
                                      name: snapshot.data[index]['name'],
                                      lang: snapshot.data[index]['lang'],
                                      index: snapshot.data[index]['sid'],
                                      ttlayas: snapshot.data[index]['ttlayas'],
                                      bookmarkAid: snapshot.data[index]['aid'],
                                    ),
                                  ),
                                );
                              },
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
                iconsName: Icons.color_lens,
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Reciter())),
              child: Heading(
                headingText: 'Reciter',
                iconsName: Icons.supervised_user_circle,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _translated = !_translated;
                });
              },
              child: Heading(
                headingText: 'Bangla Translation By',
                iconsName: Icons.language,
              ),
            ),
            Visibility(
              visible: _translated,
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: (){
                      _setAuther(0);
                    },
                      title: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Wrap(
                      children: <Widget>[
                        Icon(Icons.translate, color: _auther[0]==true ? Theme.of(context).primaryColor:Colors.black,),
                        Text('  মুরতোজা হাসান খালেদ', style: TextStyle(color: _auther[0]==true ? Theme.of(context).primaryColor:Colors.black),),
                      ],
                    ),
                  )),
                  Divider(
                    height: 0.2,
                    color: Theme.of(context).primaryColor,
                    indent: 30,
                  ),
                  ListTile(
                    onTap: (){
                      _setAuther(1);
                    },
                      title: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Wrap(
                      children: <Widget>[
                        Icon(
                          Icons.translate,
                          color: _auther[1] == true
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                        ),
                        Text(
                          '  মুহিউদ্দীন খান',
                          style: TextStyle(
                              color: _auther[1] == true
                                  ? Theme.of(context).primaryColor
                                  : Colors.black),
                        ),
                      ],
                    ),
                  )),
                  Divider(
                    height: 0.2,
                    color: Theme.of(context).primaryColor,
                    indent: 30,
                  ),
                ],
              ),
            )
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
          trailing: (widget.ttlAyas != null)
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
