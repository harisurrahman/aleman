import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final Icon icon;
  CustomListTile({Key key, this.icon}) : super(key: key);

  @override
  _CustomListTileState createState() => _CustomListTileState(icon);
}

class _CustomListTileState extends State<CustomListTile> {
  _CustomListTileState(this.icon);
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Row(
          children: <Widget>[
            icon,
            Text('')

          ],
        ),
      ),
    );
  }
}
