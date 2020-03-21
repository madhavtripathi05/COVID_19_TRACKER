import 'package:flutter/material.dart';

class DataListItem extends StatelessWidget {
  final String data;
  final bool isTitle;
  final Color myColor;

  DataListItem(this.data, [this.isTitle = false, this.myColor = Colors.white]);
  @override
  Widget build(BuildContext context) {
    return isTitle
        ? Container(
            padding: EdgeInsets.all(8),
            child: Text(
              data,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20,color: myColor,fontWeight: FontWeight.bold),
              
            ),
          )
        : Container(
            child: Column(
              children: <Widget>[
                Text(
                  data,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: myColor),
                ),
              ],
            ),
          );
  }
}
