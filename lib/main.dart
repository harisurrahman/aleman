import 'package:aleman/main_drawer.dart';

import './custom_card.dart';
import 'package:flutter/material.dart';
import 'dto/bottom_navigation.dart';
import 'dto/load_sura_list.dart';
import './sura_detail.dart';
import 'main_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//this is a comment
  int _selectedPage = 0;
  String _currentLang = 'الإيمان';

  Widget _getPage(int _index) {
    List<Widget> pages = [
      FutureBuilder(
        future: loadSuraList(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Column(
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SuraDetail(
                                    data:
                                        'assets/quran/sura-${(index + 1).toString()}.json',
                                    name: snapshot.data[index].name,
                                    lang: 'original',
                                    index: snapshot.data[index].englishNumber,
                                    ttlayas: int.parse(snapshot
                                        .data[index].numberEnglishAyahs))),
                          );
                          //print(index);
                        },
                        child: CustomCard(snapshot, index, _index),
                      ),
                    )
                  ],
                );
              },
            );
        },
      ),
      FutureBuilder(
        future: loadSuraList(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Column(
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        /* onLongPress: () {
                          bookMarkSura(/* (index, snapshot.data[index].name */);
                        }, */
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SuraDetail(
                                    data:
                                        'assets/quran/sura-${(index + 1).toString()}.json',
                                    name: snapshot.data[index].name,
                                    lang: 'bangla',
                                    index: snapshot.data[index].englishNumber,
                                    ttlayas: int.parse(snapshot
                                        .data[index].numberEnglishAyahs))),
                          );
                        },
                        child: CustomCard(snapshot, index, _index),
                      ),
                    ),
                  ],
                );
              },
            );
        },
      ),
      FutureBuilder(
        future: loadSuraList(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Column(
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SuraDetail(
                                    data:
                                        'assets/quran/sura-${(index + 1).toString()}.json',
                                    name: snapshot.data[index].name,
                                    lang: 'english',
                                    index: snapshot.data[index].englishNumber,
                                    ttlayas: int.parse(snapshot
                                        .data[index].numberEnglishAyahs))),
                          );
                        },
                        child: CustomCard(snapshot, index, _index),
                      ),
                    ),
                  ],
                );
              },
            );
        },
      ),
    ];
    return pages[_index];
  }

  @override
  void initState() {
    super.initState();
    getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _currentLang,
          style: TextStyle(fontSize: _selectedPage == 0 ? 30.0 : 25.0),
        ),
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
            switch (_selectedPage) {
              case 0:
                _currentLang = 'الإيمان';
                break;
              case 1:
                _currentLang = 'এল ঈমান';
                break;
              case 2:
                _currentLang = 'The Faith';
                break;
            }
          });
        },
        items: bottomIcons(),
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.indigo[100]),
          child: _getPage(_selectedPage)),
    );
  }
}
