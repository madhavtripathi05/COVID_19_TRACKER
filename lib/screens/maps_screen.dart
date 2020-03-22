import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../screens/charts_screen.dart';



class MapsScreen extends StatefulWidget {
  static const routeName = '/maps_screen';
  final int index;
  MapsScreen({this.index});

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> urls = [
    'https://www.bing.com/covid',
    'https://app.developer.here.com/coronavirus/',
    'https://experience.arcgis.com/experience/685d0ace521648f8a5beeeee1b9125cd'
  ];

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Live Map'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              FlutterWebviewPlugin().close();
              Navigator.pushNamed(context, ChartsScreen.routeName);
            },
          ),
        ],
      ),
      //show Map according to the selection from endDrawer
      url: urls[widget.index],
      withZoom: true,
      withLocalStorage: true,
    );
  }
}
