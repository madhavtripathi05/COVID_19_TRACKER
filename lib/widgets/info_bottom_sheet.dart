import 'package:flutter/material.dart';

import '../widgets/source_list_item.dart';

class InfoBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SourceListItem(
              'Data Source: https://www.worldometers.info/coronavirus'),
          SizedBox(height: 20),
          SourceListItem(
              'API endpoints:\n https://corona.lmao.ninja\nhttps://api.rootnet.in/covid19-in/stats'),
          SizedBox(height: 20),
          SourceListItem('Map Sources:\nMultiple(Select one from endDrawer)'),
          SizedBox(height: 20),
          SourceListItem('1) Bing(default):\nhttps://www.bing.com/covid'),
          SizedBox(height: 20),
          SourceListItem(
              '2) Here Maps:\nhttps://app.developer.here.com/coronavirus'),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
