import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dto/load_sura.dart';
import 'package:flutter/foundation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class SuraDetail extends StatefulWidget {
  final String data;
  final String name;
  final String lang;
  final int index;
  final int ttlayas;

  SuraDetail(
      {Key key,
      @required this.data,
      this.name,
      this.lang,
      this.index,
      this.ttlayas})
      : super(key: key);

  @override
  _SuraDetailState createState() =>
      _SuraDetailState(data, name, lang, index, ttlayas);
}

class _SuraDetailState extends State<SuraDetail> {
  final String data;
  final String name;
  final String lang;
  final int index;
  final int ttlayas;

  _SuraDetailState(this.data, this.name, this.lang, this.index, this.ttlayas);
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  int count = 0;
  bool pause = false;
  bool isDownload = false;
  String progress = '0';
  double parsentage = 0;
  final baseUrl = 'http://www.everyayah.com/data/Abdullah_Basfar_32kbps/';
  bool isPlaying = false;

  AudioPlayer advancedPlayer = AudioPlayer();

  //var active = List();
  List<bool> active = [false];

  Directory dir;
  @override
  void initState() {
    super.initState();

    for (int i = 1; i < ttlayas; i++) {
      active.add(false);
    }

    advancedPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.COMPLETED && count <= ttlayas) {
        advancedPlayer.play(
            '${dir.path}/${index.toString().padLeft(3, '0')}${count.toString().padLeft(3, '0')}.mp3');
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

  dowloadAyas() async {
    dir = await getApplicationDocumentsDirectory();
    for (int i = 1; i <= ttlayas; i++) {
      String sura =
          '$baseUrl${index.toString().padLeft(3, '0')}${i.toString().padLeft(3, '0')}.mp3';
      bool isExists = await File(
              '${dir.path}/${index.toString().padLeft(3, '0')}${i.toString().padLeft(3, '0')}.mp3')
          .exists();
      if (!isExists) {
        isDownload = true;
        Dio dio = Dio();
        try {
          await dio.download(sura,
              '${dir.path}/${index.toString().padLeft(3, '0')}${i.toString().padLeft(3, '0')}.mp3',
              onReceiveProgress: (rec, ttl) {
            setState(() {
              progress = ((i / ttlayas) * 100).toStringAsFixed(0);
              parsentage = (((i / ttlayas) * 100) / 100);
            });
          });
        } catch (err) {
          print(err);
        }
      }
    }
    isDownload = false;
  }

  play() async {
    for (int i = 1; i < ttlayas; i++) {
      active[i] = false;
    }
    count = 0;
    setState(() {
      isPlaying = true;
      active[count] = true;
    });
    await this.dowloadAyas();
    await advancedPlayer.play('${dir.path}/001001.mp3');
    count = index == 1 ? 2 : 1;
  }

  setBookMark(data, lang, sid, ttlayas, aid, name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('bookmarks');
    Map newBookMark = {
      'lang': lang,
      'sid': index,
      'aid': aid,
      'ttlayas': ttlayas,
      'name': name
    };

    List<Map> bookMarkList = List<Map>();
    String bookmarks = pref.getString('bookmarks');
    if (bookmarks == null) {
      bookMarkList.add(newBookMark);
      String bookmarkArray = json.encode(bookMarkList);
      pref.setString('bookmarks', bookmarkArray);
    } else {
      var jsonResp = json.decode(bookmarks);
      var inBookmark = false;
      jsonResp.forEach((bookmark) {
        if (inBookmark == false &&
            newBookMark['sid'] == bookmark['sid'] &&
            newBookMark['aid'] == bookmark['aid'] &&
            newBookMark['aid'] == bookmark['lang']) {
          inBookmark = true;
        } else {
          bookMarkList.add(bookmark);
        }
      });
      bookMarkList.add(newBookMark);

      pref.setString('bookmarks', json.encode(bookMarkList));
    }
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer = null;
  }

  selectedLang(AsyncSnapshot snapshot, int index) {
    switch (lang) {
      case 'bangla':
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
              child: Text(
                snapshot.data[index].banglaText,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        );
      case 'original':
        return Container();
      case 'english':
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
          child: Text(
            snapshot.data[index].englishText,
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xff0b4703),
            ),
          ),
        );
    }
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

              isPlaying = false;
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
              if (!isPlaying) {
                play();
                isPlaying = true;
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              if (pause == false) {
                pause = true;

                advancedPlayer.pause();
              } else {
                pause = false;
                isPlaying = false;
                advancedPlayer.resume();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              count = 0;
              isPlaying = true;
              advancedPlayer.stop();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Visibility(
          visible: isDownload,
          child: Container(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 12,
                  child: LinearProgressIndicator(
                    value: parsentage,
                    backgroundColor: Colors.black87,
                    valueColor: AlwaysStoppedAnimation(Colors.red),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 4, 4, 10),
                  child: Text(
                    'Completed..$progress %',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: SizedBox(
          child: FutureBuilder(
            future: loadSuraDetail(data),
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
                          setBookMark(data, lang, this.index, ttlayas, index+1, name);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.indigo[100],
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 4, 20, 4),
                                child: Text(
                                  snapshot.data[index].quranText,
                                  style: TextStyle(
                                    fontSize: 30.0,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              selectedLang(snapshot, index),
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
