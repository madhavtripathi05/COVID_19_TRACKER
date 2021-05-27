import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/constants.dart';
import '../services/api_data.dart';
import '../screens/dashboard.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = '/loading';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  ApiData apiData = ApiData();

  @override
  void initState() {
    if (!kIsWeb) FlutterWebviewPlugin().close();
    super.initState();
    handleLocationPermission();
    getAndSetData();
  }

  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Location is disabled :(',
            style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Enable from settings',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
            onPressed: () async {
              await openAppSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void handleLocationPermission() async {
    // Test if location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _showLocationDeniedDialog();
      return Future.error('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _showLocationDeniedDialog();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _showLocationDeniedDialog();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  void getAndSetData() async {
    var data = await apiData.getVirusData();
    var locationData = await apiData.getLocationVirusData();
    var countriesData = await apiData.getCountriesVirusData();
    var statesData = await apiData.getStatesData();
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 1000),
          pageBuilder: (context, animation, secondaryAnimation) => Dashboard(
            countriesData: countriesData,
            locationVirusData: locationData,
            virusData: data,
            statesData: statesData,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeScaleTransition(animation: animation, child: child);
          },
        ));
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
          Text('v2.0',
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
