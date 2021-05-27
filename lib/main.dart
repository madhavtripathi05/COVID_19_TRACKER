import 'package:covid_19_tracker/constants.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

import './screens/countries_info_screen.dart';
import './screens/dashboard.dart';
import './screens/info_screen.dart';
import './screens/loading_screen.dart';
import './screens/states_info_screen.dart';

void main() => runApp(EasyDynamicThemeWidget(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19 Tracker',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: LoadingScreen(),
      routes: {
        CountriesInfoScreen.routeName: (context) => CountriesInfoScreen(),
        Dashboard.routeName: (context) => Dashboard(),
        InfoScreen.routeName: (context) => InfoScreen(),
        LoadingScreen.routeName: (context) => LoadingScreen(),
        StatesInfoScreen.routeName: (context) => StatesInfoScreen(),
      },
    );
  }
}
