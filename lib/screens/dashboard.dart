import 'package:animations/animations.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../screens/charts_screen.dart';
import '../screens/countries_info_screen.dart';
import '../screens/states_info_screen.dart';

import '../constants/constants.dart';

import '../extensions/hover_extension.dart';

import '../models/virus_data.dart';
import '../models/country_virus_data.dart';

import '../screens/loading_screen.dart';
import '../screens/maps_screen.dart';

import '../widgets/data_list_item.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  Dashboard(
      {this.locationVirusData,
      this.virusData,
      this.countriesData,
      this.statesData});
  final virusData;
  final locationVirusData;
  final countriesData;
  final statesData;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  VirusData? data;
  CountryVirusData? locationData;
  int index = 0;
  List<CountryVirusData> countriesData = [];
  bool isLight = false;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    updateUI(widget.virusData);

    updateLocationUI(widget.locationVirusData);
    updateCountriesUI(widget.countriesData);
    super.initState();
  }

  void updateUI(dynamic virusData) {
    setState(() {
      if (virusData == null) {
        data = VirusData(
          confirmedCases: 0,
          recovered: 0,
          deaths: 0,
        );
        return;
      }

      data = VirusData(
        confirmedCases: virusData['cases'],
        recovered: virusData['recovered'],
        deaths: virusData['deaths'],
      );
    });
  }

  void updateCountriesUI(dynamic virusData) {
    setState(() {
      if (virusData == null) {
        locationData = CountryVirusData(
          country: 'none',
          confirmedCases: 0,
          recovered: 0,
          deaths: 0,
        );
        print('error Null data obtained');
        return;
      }
      for (var eachData in virusData) {
        final countryData = CountryVirusData(
          country: eachData['country'],
          confirmedCases: eachData['cases'],
          recovered: eachData['recovered'],
          deaths: eachData['deaths'],
          todayCases: eachData['todayCases'],
          criticalCases: eachData['critical'],
          todayDeaths: eachData['todayDeaths'],
          flagUrl: eachData['countryInfo']['flag'],
        );
        countriesData.add(countryData);
      }
    });
  }

  void updateLocationUI(dynamic virusData) {
    setState(() {
      if (virusData == null) {
        locationData = CountryVirusData(
          country: 'none',
          confirmedCases: 0,
          recovered: 0,
          deaths: 0,
        );
        return;
      }

      locationData = CountryVirusData(
        country: virusData['country'],
        confirmedCases: virusData['cases'],
        recovered: virusData['recovered'],
        deaths: virusData['deaths'],
        todayCases: virusData['todayCases'],
        criticalCases: virusData['critical'],
        todayDeaths: virusData['todayDeaths'],
      );
    });
  }

  Widget options() {
    return Container(
      padding: EdgeInsets.all(10),
      width: 500,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Text('COVID-19 TRACKER', style: kHeadingTextStyle),
            SizedBox(height: 20),
            Text('Select Map Provider :', style: kHeadingTextStyle),
            SizedBox(height: 20),
            ListTile(
                title: Text('Bing', style: kHeadingTextStyle),
                subtitle:
                    Text('https://www.bing.com/covid', style: kUrlTextStyle),
                leading: Image.asset(
                  'assets/images/bing.png',
                  height: 50,
                  width: 50,
                  color: !isLight ? Colors.white : Colors.black,
                ),
                trailing: Icon(
                  index == 0 ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isLight ? Colors.black : Colors.white,
                ),
                onTap: () => setState(() => index = 0)),
            ListTile(
                leading: Image.asset(
                  'assets/images/here.png',
                  height: 50,
                  width: 50,
                  color: isLight ? Colors.black : Colors.white,
                ),
                title: Text('Here', style: kHeadingTextStyle),
                subtitle: Text('https://app.developer.here.com/coronavirus/',
                    style: kUrlTextStyle),
                trailing: Icon(
                  index == 1 ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isLight ? Colors.black : Colors.white,
                ),
                onTap: () => setState(() => index = 1)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isLight = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'COVID-19 Tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.blueAccent),
                ),
                SizedBox(height: 20),
                Hero(
                  tag: 'Countries',
                  child: Card(
                    elevation: 7,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CountriesInfoScreen(
                              countryVirusData: widget.countriesData,
                            ),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeScaleTransition(
                                  animation: animation, child: child);
                            },
                          )),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            DataListItem(
                                'Worldwide', true, Colors.deepOrangeAccent),
                            DataListItem('Confirmed: ${data!.confirmedCases}',
                                false, Colors.amber),
                            DataListItem('Recovered: ${data!.recovered}', false,
                                Colors.green),
                            DataListItem(
                                'Deaths: ${data!.deaths}', false, Colors.red),
                          ],
                        ),
                      ),
                    ),
                  ).translateOnHover,
                ),
                Hero(
                  tag: 'States',
                  child: Card(
                    elevation: 7,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => locationData!.country == 'India'
                          ? Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        StatesInfoScreen(
                                  stateVirusData: widget.statesData,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return SharedAxisTransition(
                                    child: child,
                                    animation: animation,
                                    secondaryAnimation: secondaryAnimation,
                                    transitionType:
                                        SharedAxisTransitionType.scaled,
                                  );
                                },
                              ))
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            DataListItem('${locationData!.country}', true,
                                Colors.deepOrangeAccent),
                            DataListItem(
                                'Confirmed: ${locationData!.confirmedCases}',
                                false,
                                Colors.amber),
                            DataListItem(
                                'Recovered: ${locationData!.recovered}',
                                false,
                                Colors.green),
                            DataListItem('Deaths: ${locationData!.deaths}',
                                false, Colors.red),
                          ],
                        ),
                      ),
                    ),
                  ).translateOnHover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Last updated: ${DateTime.now().toString().substring(0, 10)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 7, color: Colors.greenAccent),
                  ),
                ),
                Container(
                  height: 130,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildCard(
                            context: context,
                            icon: Icons.show_chart,
                            screen: ChartsScreen(
                              countryName: locationData!.country!,
                              cases: double.parse(
                                  '${locationData!.confirmedCases}'),
                              deaths: double.parse('${locationData!.deaths}'),
                              recovered:
                                  double.parse('${locationData!.recovered}'),
                            ),
                            title: 'InfoGraphs'),
                        buildCard(
                            context: context,
                            screen: CountriesInfoScreen(
                                countryVirusData: widget.countriesData),
                            img: 'assets/images/world.png',
                            title: 'All Countries'),
                        buildCard(
                            context: context,
                            screen: StatesInfoScreen(
                                stateVirusData: widget.statesData),
                            img: 'assets/images/india.png',
                            title: 'States of India'),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 120,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildCard(
                            context: context,
                            screen: LoadingScreen(),
                            icon: Icons.refresh,
                            title: 'Refresh Data'),
                        buildCard(
                            context: context,
                            icon: isLight
                                ? Icons.wb_incandescent
                                : Icons.lightbulb_outline,
                            onTap: () => setState(
                                  () {
                                    if (isLight) {
                                      isLight = !isLight;
                                      EasyDynamicTheme.of(context)
                                          .changeTheme(dark: true);
                                    } else {
                                      isLight = !isLight;
                                      EasyDynamicTheme.of(context)
                                          .changeTheme(dark: false);
                                    }
                                  },
                                ),
                            title: isLight ? ' Dark Theme' : ' Light Theme'),
                        buildCard(
                            context: context,
                            screen: MapsScreen(index: index),
                            onTap: kIsWeb
                                ? () async {
                                    final urlString =
                                        'https://app.developer.here.com/coronavirus/';
                                    if (await canLaunch(urlString))
                                      launch(urlString);
                                    else
                                      print('can\'t launch this url');
                                  }
                                : null,
                            icon: Icons.map,
                            title: 'Live Maps'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final url = 'mailto:madhavcodes@gmail.com';
                    if (await canLaunch(url))
                      await launch(url);
                    else
                      print('can\'t launch url');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text('Designed and Developed with 💙 by \nMadhav ',
                        textAlign: TextAlign.center),
                  ),
                ),
                SizedBox(height: 10),
                Text('v 2.0'),
              ],
            ),
          ),
        ),
      ),
      endDrawer: Drawer(child: options()),
    );
  }

  Widget buildCard(
      {required BuildContext context,
      required String title,
      Widget? screen,
      IconData? icon,
      dynamic onTap,
      String? img}) {
    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap == null
            ? () => Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      screen!,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SharedAxisTransition(
                      child: child,
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.scaled,
                    );
                  },
                ))
            : onTap,
        child: Container(
          width: 110,
          height: 110,
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              icon != null
                  ? Icon(
                      icon,
                      color: !isLight ? Colors.white : Colors.black,
                    )
                  : Image.asset(
                      img!,
                      height: 50,
                      width: 50,
                      color: !isLight ? Colors.white : Colors.black,
                    ),
              SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).translateOnHover;
  }
}
