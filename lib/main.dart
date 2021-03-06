import 'package:provider/provider.dart';
import './custom_card.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation.dart';
import './sura_detail.dart';
import 'main_drawer.dart';
import 'theme.dart';
import 'bloc/sura_list_bloc.dart';
import 'commonFunctions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(themes[1]),
      child: MaterialAppWithTheme(),
    );
  }

  MaterialApp buildMaterialAppWithTheme() {
    return MaterialApp(
      title: 'Al Amin',
      home: HomePage(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _currentTheme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: _currentTheme.getTheme(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  String _currentLang = 'الإيمان';
  SuraListBloc _suraBloc;

  Widget _getPage(int _index) {
    List<Widget> pages = [
      StreamBuilder(
        stream: _suraBloc.getSuraListStream,
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
                      /* color: Colors.transparent, */
                      child: InkWell(
                        splashColor: Theme.of(context).primaryColor,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SuraDetail(
                                name: snapshot.data[index].originalName,
                                lang: 'original',
                                index: snapshot.data[index].sid,
                                ttlayas: snapshot.data[index].numberOfAyets,
                              ),
                            ),
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
      StreamBuilder(
        stream: _suraBloc.getSuraListStream,
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
                      /* color: Colors.transparent, */
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SuraDetail(
                                  name: snapshot.data[index].banglaName,
                                  lang: 'bangla',
                                  index: snapshot.data[index].sid,
                                  ttlayas: snapshot.data[index].numberOfAyets),
                            ),
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
      StreamBuilder(
        stream: _suraBloc.getSuraListStream,
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
                      /* color: Colors.transparent, */
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SuraDetail(
                                name: snapshot.data[index].englishName,
                                lang: 'english',
                                index: snapshot.data[index].sid,
                                ttlayas: snapshot.data[index].numberOfAyets,
                              ),
                            ),
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
    _suraBloc = SuraListBloc();
    copyFromAssets();

    super.initState();
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
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
            switch (_selectedPage) {
              case 0:
                _currentLang = 'الإيمان';
                break;
              case 1:
                _currentLang = 'আল ঈমান';
                break;
              case 2:
                _currentLang = 'Al Iman';
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
