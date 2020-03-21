import 'package:covid_19_tracker/screens/countries_info_screen.dart';
import 'package:covid_19_tracker/screens/info_screen.dart';
import 'package:covid_19_tracker/screens/states_info_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import './screens/dashboard.dart';
import './screens/charts_screen.dart';
import './screens/maps_screen.dart';
import './screens/loading_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
          primarySwatch: Colors.blue,
          brightness: brightness,
          fontFamily: 'google'),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'COVID-19 tracker',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: LoadingScreen(),
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
