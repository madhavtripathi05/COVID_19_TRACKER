import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  Future<void> urlDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Map Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${urls[widget.index]}'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay!'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapsScreen(index: widget.index)));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Live Map'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.infoCircle),
              onPressed: () {
                Navigator.pop(context);
                FlutterWebviewPlugin().dispose();
                urlDialog();
              }),
        ],
      ),
      //show Map according to the selection from endDrawer
      url: urls[widget.index],
      withZoom: true,
      withLocalStorage: true,
    );
  }
}
