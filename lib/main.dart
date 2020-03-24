import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import './screens/charts_screen.dart';
import './screens/countries_info_screen.dart';
import './screens/dashboard.dart';
import './screens/info_screen.dart';
import './screens/loading_screen.dart';
import './screens/maps_screen.dart';
import './screens/states_info_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        primarySwatch: Colors.blue,
        brightness: brightness,
        fontFamily: 'google',
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'COVID-19 Tracker',
          debugShowCheckedModeBanner: false,
          theme: theme,
          //  don't forget to uncomment the following line.
          home: LoadingScreen(),
          // home: ChartsScreen(),
          routes: {
            ChartsScreen.routeName: (context) => ChartsScreen(),
            CountriesInfoScreen.routeName: (context) => CountriesInfoScreen(),
            Dashboard.routeName: (context) => Dashboard(),
            InfoScreen.routeName: (context) => InfoScreen(),
            LoadingScreen.routeName: (context) => LoadingScreen(),
            MapsScreen.routeName: (context) => MapsScreen(),
            StatesInfoScreen.routeName: (context) => StatesInfoScreen(),
          },
        );
      },
    );
  }
}
