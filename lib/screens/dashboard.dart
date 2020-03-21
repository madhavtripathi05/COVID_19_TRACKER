import 'package:covid_19_tracker/screens/countries_info_screen.dart';
import 'package:covid_19_tracker/screens/states_info_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

import '../models/virus_data.dart';
import '../models/country_virus_data.dart';

import '../screens/info_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/maps_screen.dart';

import '../widgets/data_list_item.dart';
import '../widgets/info_bottom_sheet.dart';

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
  VirusData data;
  CountryVirusData locationData;
  int index = 0;
  List<CountryVirusData> countriesData = [];
  // var brightness = DynamicThemeState().brightness;//redundant
  bool isLight = DynamicThemeState().brightness == Brightness.light;
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
        confirmedCases: virusData['cases'] ?? 0,
        recovered: virusData['recovered'] ?? 0,
        deaths: virusData['deaths'] ?? 0,
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
          country: eachData['country'] ?? 'None',
          confirmedCases: eachData['cases'] ?? 0,
          recovered: eachData['recovered'] ?? 0,
          deaths: eachData['deaths'] ?? 0,
          todayCases: eachData['todayCases'] ?? 0,
          criticalCases: eachData['critical'] ?? 0,
          todayDeaths: eachData['todayDeaths'] ?? 0,
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
        country: virusData['country'] ?? 'None',
        confirmedCases: virusData['cases'] ?? 0,
        recovered: virusData['recovered'] ?? 0,
        deaths: virusData['deaths'] ?? 0,
        todayCases: virusData['todayCases'] ?? 0,
        criticalCases: virusData['critical'] ?? 0,
        todayDeaths: virusData['todayDeaths'] ?? 0,
      );
    });
  }

  final flutterLogo = FlutterLogo();
  Widget options() {
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Text('COVID-19 TRACKER', style: kHeadingTextStyle),
            SizedBox(height: 20),
            Text('build: v0.6.5 Beta'),
            SizedBox(height: 20),
            Text(
              'Under Development\nThanks for testing!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
                'Designed and Developed\n with ❤  by: \nMadhav Tripathi',
                textAlign: TextAlign.center),
            SizedBox(height: 20),
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
                  color: isLight ? Colors.black : Colors.white,
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
            ListTile(
                leading: Image.asset(
                  'assets/images/who.png',
                  height: 50,
                  width: 50,
                  color: isLight ? Colors.black : Colors.white,
                ),
                title: Text('WHO', style: kHeadingTextStyle),
                subtitle: Text('https://experience.arcgis.com/experience',
                    style: kUrlTextStyle),
                trailing: Icon(
                  index == 2 ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isLight ? Colors.black : Colors.white,
                ),
                onTap: () => setState(() => index = 2)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                'COVID-19 Tracker',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => locationData.country == 'India'
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                        return CountriesInfoScreen(
                          countryVirusData: widget.countriesData,
                        );
                      }))
                    : null,
                child: Hero(
                  tag: 'Countries',
                  child: Card(
                    elevation: 7,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          DataListItem(
                              'Worldwide', true, Colors.deepOrangeAccent),
                          DataListItem('Confirmed: ${data.confirmedCases}',
                              false, Colors.amber),
                          DataListItem('Recovered: ${data.recovered}', false,
                              Colors.green),
                          DataListItem(
                              'Deaths: ${data.deaths}', false, Colors.red),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => locationData.country == 'India'
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                        return StatesInfoScreen(
                          stateVirusData: widget.statesData,
                        );
                      }))
                    : null,
                child: Hero(
                  tag: 'States',
                  child: Card(
                    elevation: 7,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          DataListItem('${locationData.country}', true,
                              Colors.deepOrangeAccent),
                          DataListItem(
                              'Confirmed: ${locationData.confirmedCases}',
                              false,
                              Colors.amber),
                          DataListItem('Recovered: ${locationData.recovered}',
                              false, Colors.green),
                          DataListItem('Deaths: ${locationData.deaths}', false,
                              Colors.red),

                          // DataListItem('Critical Cases ${locationData.criticalCases}'),
                          // DataListItem('Today\'s Cases: ${locationData.todayCases}'),
                          // DataListItem('Today\'s Deaths: ${locationData.todayDeaths}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Last updated: ${DateTime.now().toString().substring(0, 10)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 7, color: Colors.greenAccent),
                ),
              ),
              SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.map),
                          Text(' Live Maps'),
                        ],
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapsScreen(
                            index: index,
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.refresh),
                          Text(' Refresh Data'),
                        ],
                      ),
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, LoadingScreen.routeName),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Row(children: [
                        Image.asset(
                          'assets/images/world.png',
                          height: 50,
                          width: 50,
                          color: isLight ? Colors.black : Colors.white,
                        ),
                        Text(' All Countries'),
                      ]),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CountriesInfoScreen(
                          countryVirusData: widget.countriesData,
                        );
                      })),
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/india.png',
                            height: 50,
                            width: 50,
                            color: isLight ? Colors.black : Colors.white,
                          ),
                          Text(' States of India'),
                        ],
                      ),
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return StatesInfoScreen(
                          stateVirusData: widget.statesData,
                        );
                      })),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Row(children: [
                        Icon(Icons.info_outline),
                        Text(' About Sources'),
                      ]),
                      onPressed: () =>
                          _scaffoldKey.currentState.showBottomSheet(
                        (context) => InfoBottomSheet(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.info),
                          Text(' About COVID-19'),
                        ],
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, InfoScreen.routeName),
                    ),
                  ],
                ),
              ),

              FlatButton(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  isLight
                      ? Icon(Icons.wb_incandescent, color: Colors.black)
                      : Icon(Icons.lightbulb_outline),
                  Text(isLight ? ' Dark Theme' : ' Light Theme'),
                ]),
                onPressed: () => setState(
                  () {
                    if (isLight) {
                      // brightness = Brightness.dark;
                      isLight = !isLight;
                      DynamicTheme.of(context).setBrightness(Brightness.dark);
                    } else if (!isLight) {
                      isLight = !isLight;
                      // brightness = Brightness.light;
                      DynamicTheme.of(context).setBrightness(Brightness.light);
                    } else {
                      isLight =
                          DynamicThemeState().brightness == Brightness.light;
                      // brightness = Brightness.dark;
                      DynamicTheme.of(context).setBrightness(Brightness.dark);
                    }
                  },
                ),
              ),
              // Expanded(child: buildList()),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: options(),
      ),
    );
  }
}
