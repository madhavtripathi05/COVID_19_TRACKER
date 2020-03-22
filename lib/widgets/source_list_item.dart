import 'package:flutter/material.dart';

class SourceListItem extends StatelessWidget {
  final String data;
  SourceListItem(this.data);
  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: TextAlign.center,
    );
  }
}
