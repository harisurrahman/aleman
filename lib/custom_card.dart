import 'package:flutter/material.dart';
import 'package:persian/persian.dart';
import 'number_translate.dart';

class CustomCard extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final int index;
  final int lang;
  CustomCard(this.snapshot, this.index, this.lang);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 5.0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          color: null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: SizedBox(
                width: 80.0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10.0, 0, 0),
                      child: Image.asset(
                        snapshot.data[index].revelationType == 'Meccan'
                            ? 'assets/images/madina.png'
                            : 'assets/images/kaba.png',
                        height: 35.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 5.0, 0, 5),
                      child: SizedBox(
                          width: 100.0,
                          child: Text(
                            _getAyahsNumber(snapshot, index, lang),
                            style: TextStyle(
                              fontSize: lang == 0
                                  ? 14.0
                                  : 12.0, /* fontWeight: lang == 0 ? FontWeight.bold:FontWeight.normal */
                            ),
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      (lang == 1)
                          ? snapshot.data[index].banglaTranslated
                          : snapshot.data[index].englishTranslated,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      _suraName(snapshot, index, lang),
                      style: TextStyle(
                          fontSize: lang == 0 ? 25.0 : 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: _otherLang(snapshot, index, lang),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: CircleAvatar(
                radius: 25,
                child: Text(
                  _suraNumber(snapshot, index, lang),
                  style: TextStyle(
                    fontSize: lang == 0 ? 30.0 : 20.0,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

_suraName(snapshot, int index, int lang) {
  switch (lang) {
    case 0:
      return snapshot.data[index].originalName;
      break;
    case 1:
      return snapshot.data[index].banglaName;
    case 2:
      return snapshot.data[index].englishName;
  }
}

_suraNumber(snapshot, int index, int lang) {
  switch (lang) {
    case 0:
      return snapshot.data[index].sid.toString().withPersianNumbers();
      break;
    case 1:
      return snapshot.data[index].sid.toString().withBanglaNumbers();
    case 2:
      return snapshot.data[index].sid.toString();
  }
}

/* otherLang(snapshot, int index, int lang) {
  switch (lang) {
    case 0:
      return '${snapshot.data[index].banglaName} / ${snapshot.data[index].englishName}';
      break;
    case 1:
      return '${snapshot.data[index].name} / ${snapshot.data[index].englishName}';
      break;
    case 2:
      return '${snapshot.data[index].name} / ${snapshot.data[index].banglaName}';
  }
} */

Widget _otherLang(snapshot, int index, int lang) {
  Widget _others;
  switch (lang) {
    case 0:
      _others = Wrap(
        children: <Widget>[
          Text(
            '${snapshot.data[index].banglaName}',
            style: TextStyle(fontSize: 12.0),
          ),
          Text(
            ' / ${snapshot.data[index].englishName}',
            style: TextStyle(fontSize: 12.0),
          ),
        ],
      );
      break;
    case 1:
      _others = Wrap(
        children: <Widget>[
          Text(
            '${snapshot.data[index].originalName}',
            style: TextStyle(
              fontSize: 14.0,
              height: .9,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' / ${snapshot.data[index].englishName}',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
      break;
    case 2:
      _others = Wrap(
        children: <Widget>[
          Text(
            '${snapshot.data[index].originalName}',
            style: TextStyle(
              fontSize: 14.0,
              height: .9,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ' / ${snapshot.data[index].banglaName}',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
      break;
  }
  return _others;
}

_getAyahsNumber(snapshot, int index, int lang) {
  switch (lang) {
    case 0:
      return 'الآيات ${snapshot.data[index].numberOfAyets.toString().withPersianNumbers()}';
      break;
    case 1:
      return 'আয়াত ${snapshot.data[index].numberOfAyets.toString().withBanglaNumbers()}';
      break;
    case 2:
      return 'Ayahs ${snapshot.data[index].numberOfAyets}';
  }
}
