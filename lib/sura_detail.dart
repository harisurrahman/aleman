import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'commonFunctions.dart';
import 'bloc/progress_bloc.dart';
import 'reciters.dart';

class SuraDetail extends StatefulWidget {
  /* final String data; */
  final String name;
  final String lang;
  final int index;
  final int ttlayas;
  final int bookmarkAid;

  SuraDetail(
      {Key key,
      /* @required this.data, */
      this.name,
      this.lang,
      this.index,
      this.ttlayas,
      this.bookmarkAid})
      : super(key: key);

  @override
  _SuraDetailState createState() =>
      _SuraDetailState(/* data, */ name, lang, index, ttlayas, bookmarkAid);
}

class _SuraDetailState extends State<SuraDetail> {
  /* final String data; */
  final String name;
  final String lang;
  final int index;
  final int ttlayas;
  final int bookmarkAid;

  _SuraDetailState(
      this.name, this.lang, this.index, this.ttlayas, this.bookmarkAid);
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  int count = 0;
  bool _pause = false;
  bool _isPlaying = false;
  bool exists = false;
  ProgressBloc _bloc;
  AudioPlayer advancedPlayer = AudioPlayer();
  List<bool> active;
  Directory dir;
  SharedPreferences _pref;
  String reciterFolder;
  int reciter;
  List<Color> bookmarkColor;
  @override
  void initState() {
    super.initState();

    bookmarkColor = List.filled(ttlayas, Colors.black);

    _bloc = ProgressBloc();
    _bloc.getSuraAyesAid.add(index);
    SharedPreferences.getInstance().then((value) {
      _pref = value;
      reciter = _pref.getInt('current_reciter');
      reciterFolder = reciters[reciter]['name'].replaceAll(' ', '-');
    });

    getApplicationDocumentsDirectory().then((value) {
      dir = value;
      File('${dir.path}/$reciterFolder/001001.mp3').exists().then((exists) {
        if (!exists) {
          _bloc.getSid.add(1);
        }
      });
    });

    active = List.filled(ttlayas, false);

    if (bookmarkAid != null) {
      _resumePlay();
    }

    advancedPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.COMPLETED && count <= ttlayas) {
        advancedPlayer.play(
            '${dir.path}/$reciterFolder/${index.toString().padLeft(3, '0')}${count.toString().padLeft(3, '0')}.mp3');
        count++;
        setState(() {
          active[count - 2] = true;
          active[count - 3] = false;
        });

        itemScrollController.scrollTo(
            index: (count - 2),
            duration: Duration(seconds: 2),
            curve: Curves.easeInOutCubic);
      }
    });

    advancedPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.STOPPED) {
        setState(() {
          active[ttlayas] = false;
        });
      }
    });
  }

  _resumePlay() async {
    Future.delayed(Duration(seconds: 1), () {
      for (int i = 1; i < ttlayas; i++) {
        active[i] = false;
      }
      setState(() {
        active[bookmarkAid - 1] = true;
        bookmarkColor[bookmarkAid - 1] = Theme.of(context).primaryColor;
      });
      count = bookmarkAid - 1;
      itemScrollController.scrollTo(
          index: bookmarkAid - 1,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOutCubic);
    });
  }

  _play() async {
    for (int i = 1; i < ttlayas; i++) {
      active[i] = false;
    }

    dir = await getApplicationDocumentsDirectory();
    if (bookmarkAid != null) {
      count = bookmarkAid;
      print(
          '${dir.path}/$reciterFolder/${index.toString().padLeft(3, '0')}${(count).toString().padLeft(3, '0')}.mp3');
      await advancedPlayer
          .play(
              '${dir.path}/$reciterFolder/${index.toString().padLeft(3, '0')}${(count).toString().padLeft(3, '0')}.mp3')
          .then((onValue) {
        setState(() {
          active[count - 1] = true;
        });
        count = count + 1;
      });
    } else {
      count = index == 1 ? 2 : 1;
      String bismillah = '';
      if (reciterFolder == 'Yassin-Al-Jazaery') {
        bismillah = '${index.toString().padLeft(3, '0')}001';
        count = count + 1;
      } else {
        if (index != 9) {
          bismillah = '001001';
        } else {
          bismillah = '${index.toString().padLeft(3, '0')}001';
          count = count + 1;
        }
      }
      await advancedPlayer.play('${dir.path}/$reciterFolder/$bismillah.mp3');
      setState(() {
        active[count - count] = true;
      });
    }
  }

  setBookMark(lang, sid, ttlayas, aid, name) async {
    _pref = await SharedPreferences.getInstance();

    colorizeBookmark(aid);
    Map newBookMark = {
      'lang': lang,
      'sid': index,
      'aid': aid,
      'ttlayas': ttlayas,
      'name': name
    };

    List<Map> bookMarkList = List<Map>();
    String bookmarks = _pref.getString('bookmarks');
    if (bookmarks == null) {
      bookMarkList.add(newBookMark);
      String bookmarkArray = json.encode(bookMarkList);
      _pref.setString('bookmarks', bookmarkArray);
    } else {
      var jsonResp = json.decode(bookmarks);
      var inBookmark = false;
      jsonResp.forEach((bookmark) {
        if (inBookmark == false &&
            newBookMark['sid'] == bookmark['sid'] &&
            newBookMark['aid'] == bookmark['aid'] &&
            newBookMark['lang'] == bookmark['lang']) {
          inBookmark = true;
        } else {
          bookMarkList.add(bookmark);
        }
      });
      bookMarkList.add(newBookMark);

      _pref.setString('bookmarks', json.encode(bookMarkList));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    advancedPlayer = null;
  }

  selectedLang(AsyncSnapshot snapshot, int index) {
    switch (lang) {
      case 'bangla':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Text(
                snapshot.data[index].banglaTranslit,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
              child: Text(
                snapshot.data[index].banglaText,
                style: TextStyle(
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
      case 'original':
        return Container();
      case 'english':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Text(
                snapshot.data[index].englishTranslit,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
              child: Text(
                snapshot.data[index].englishText,
                style: TextStyle(
                  fontSize: 17.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
    }
  }

  colorizeBookmark(int index) {
    setState(() {
      /* if (bookmarkAid != null) {
        bookmarkColor[bookmarkAid - 1] = Colors.black;
      } */
      bookmarkColor[index-1] = Theme.of(context).primaryColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //count = 0;

              _isPlaying = false;
              advancedPlayer.stop();
              advancedPlayer = null;
              Navigator.pop(context);
            }),
        title: Center(
            child: Text(
          name,
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              if (!_isPlaying) {
                _bloc.getSid.add(index);
                _play();
                //_checkDownloadStatus();
                _isPlaying = true;
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              if (_pause == false) {
                _pause = true;

                advancedPlayer.pause();
              } else {
                _pause = false;
                _isPlaying = false;
                advancedPlayer.resume();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              count = 0;
              _isPlaying = false;
              advancedPlayer.stop();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: StreamBuilder<bool>(
            initialData: false,
            stream: _bloc.getVisibilityStreamController,
            builder: (ctx, vsnap) {
              return Visibility(
                visible: vsnap.data,
                child: StreamBuilder<double>(
                    stream: _bloc.getProgressStreamController,
                    initialData: 0,
                    builder: (context, snapshot) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                                height: 12,
                                child: LinearProgressIndicator(
                                  value: (snapshot.data) / 100,
                                  backgroundColor: Colors.grey[400],
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.red),
                                )),
                            Container(
                                padding: EdgeInsets.fromLTRB(20.0, 4, 4, 10),
                                child: Text(
                                  'Completed..% ${((snapshot.data)).toStringAsFixed(0)}',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        ),
                      );
                    }),
              );
            }),
      ),
      body: Container(
        child: SizedBox(
          child: StreamBuilder(
            stream: _bloc.geSuraAyasStreamController,
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ScrollablePositionedList.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Material(
                      color: active[index] ? Color(0xffededf4) : Colors.white,
                      child: InkWell(
                        /*  highlightColor: Theme.of(context).primaryColor, */
                        splashColor: Theme.of(context).primaryColor,
                        onLongPress: () {
                          setBookMark(
                              lang, this.index, ttlayas, index + 1, name);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.3,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            /*crossAxisAlignment: CrossAxisAlignment.end, */
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 4, 20, 4),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  /*  mainAxisAlignment: MainAxisAlignment.start, */
                                  textDirection: TextDirection.rtl,
                                  children: <Widget>[
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        snapshot.data[index].quranText.trim(),
                                        style: TextStyle(
                                            fontSize: 25.0,
                                            color: bookmarkColor[index]),
                                        /* textDirection: TextDirection.rtl,  */
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(
                                          "assets/images/ayetNo.png"),
                                      child: Text(
                                        getNumsAsLang(lang, index + 1),
                                        style: TextStyle(color: Colors.black),
                                        /* style: TextStyle(fontSize: ), */
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              selectedLang(snapshot, index),
                              /* selectTranslitration(snapshot, index), */
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
