import 'package:flutter/material.dart';

class SourceListItem extends StatelessWidget {
  final String data;
  SourceListItem(this.data);
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      // style: TextStyle(color: Colors.greenAccent),
      textAlign: TextAlign.center,
    );
  }
}
