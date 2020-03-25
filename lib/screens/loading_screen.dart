import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../constants/constants.dart';
import '../services/scraper.dart';
import '../services/api_data.dart';
import '../screens/dashboard.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/loading';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  ApiData apiData = ApiData();
  Scraper scraper = Scraper();

  static bool isLight = DynamicThemeState().brightness == Brightness.light;
  @override
  void initState() {
    FlutterWebviewPlugin().close();
    super.initState();
    getAndSetData();
  }

  void getAndSetData() async {
    var data = await apiData.getVirusData();
    var locationData = await apiData.getLocationVirusData();
    var countriesData = await apiData.getCountriesVirusData();
    var statesData = await scraper.initiate();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Dashboard(
        countriesData: countriesData,
        locationVirusData: locationData,
        virusData: data,
        statesData: statesData,
      );
    }));
  }

  final spinkit1 = SpinKitPulse(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey[500],
        ),
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'COVID-19 TRACKER',
            style: kHeadingTextStyle.copyWith(color: Colors.blue),
          ),
          Text('v1.0',
              style: kUrlTextStyle.copyWith(color: Colors.amberAccent)),
          SizedBox(height: 20),
          Text(
            'fetching data, please wait...\n',
          ),
          spinkit1
        ],
      )),
    );
  }
}
