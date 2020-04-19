import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dto/load_sura.dart';
import 'package:flutter/foundation.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
          'http://www.everyayah.com/data/Abdul_Basit_Murattal_192kbps/${index.toString().padLeft(3, '0')}${i.toString().padLeft(3, '0')}.mp3';
      bool isExists = await File(
              '${dir.path}/${index.toString().padLeft(3, '0')}${i.toString().padLeft(3, '0')}.mp3')
          .exists();
      if (!isExists) {
        Dio dio = Dio();
        await dio.download(sura,
            '${dir.path}/${index.toString().padLeft(3, '0')}${i.toString().padLeft(3, '0')}.mp3',
            onReceiveProgress: (rec, ttl) {
          //setState(() {
          //progress = 'Progress : $i of 285';
          //});
        });
      }
    }
  }

  play() async {
    for (int i = 1; i < ttlayas; i++) {
      active[i] = false;;
    }
    count = 0;
    setState(() {
      active[count] = true;
    });
    await this.dowloadAyas();
    await advancedPlayer
        .play('${dir.path}/${index.toString().padLeft(3, '0')}001.mp3');
    count = 2;
  }

  
  @override
  void dispose() {
    super.dispose();
    advancedPlayer = null;
  }

  selectedLang(AsyncSnapshot snapshot, int index) {
    switch (lang) {
      case 'bangla':
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
          child: Text(
            snapshot.data[index].banglaText,
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xff0b4703),
            ),
          ),
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
              count = 0;
              advancedPlayer.stop();
              advancedPlayer.release();
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
            onPressed: play,
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: (){
              if(pause ==  false){
                pause=true;
                advancedPlayer.pause();
              }else{
                pause=false;
                advancedPlayer.resume();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              count = 0;
              advancedPlayer.stop();
            },
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: loadSuraDetail(data),
          builder: (BuildContext ctx, AsyncSnapshot snapshot) {
            if (!snapshot.hasData || snapshot.data.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ScrollablePositionedList.builder(
                  itemCount: snapshot.data.length,
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemBuilder: (BuildContext ctx, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                          child: Text(
                            snapshot.data[index].quranText,
                            style: TextStyle(
                                fontSize: 30.0,
                                /* color: snapshot.data[index].active ?  Colors.orangeAccent:Color(0xff0b4703), */
                                color: active[index]
                                    ? Colors.orangeAccent
                                    : Color(0xff0b4703)),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        selectedLang(snapshot, index),
                        /* Padding(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                          child: Text(
                            snapshot.data[index].banglaText,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color(0xff0b4703),
                            ),
                          ),
                        ),*/
                        Divider(
                          thickness: 1,
                        )
                      ],
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
