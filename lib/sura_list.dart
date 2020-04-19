import 'models/sura_list_model.dart';
import 'package:flutter/material.dart';

class SuraListTile extends StatefulWidget {
  final SuraList sura;
  SuraListTile(this.sura);

  @override
  _SuraListTileState createState() => _SuraListTileState();
}

class _SuraListTileState extends State<SuraListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading(),
    );
  }
}

Widget leading() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(
        width: 80.0,
        child: Center(
          child: CircleAvatar(
            child: Text('data'),
          ),
        ),
      ),
      SizedBox(
        width: 80.0,
        child: Center(
          child: Text('data'),
        ),
      ),
    ],
  );
}
