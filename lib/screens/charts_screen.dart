import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/api_data.dart';
import '../constants/constants.dart';
import '../models/country_historical_data.dart';

class ChartsScreen extends StatefulWidget {
  static const routeName = '/charts';
  final String countryName;
  final double cases;
  final double deaths;
  final double recovered;
  ChartsScreen({this.countryName, this.cases, this.deaths, this.recovered});
  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  @override
  void initState() {
    getAndSetData();

    _dataMap.putIfAbsent('cases', () => widget.cases ?? 0);
    _dataMap.putIfAbsent('deaths', () => widget.deaths ?? 0);
    _dataMap.putIfAbsent('recovered', () => widget.recovered ?? 0);
    super.initState();
  }

  ApiData apiData = ApiData();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<IndiaHistoricalData> countryData = [];
  List<charts.Series<IndiaHistoricalData, int>> _lineSeriesData = [];
  Map<String, double> _dataMap = Map();

  Map<String, dynamic> cases = Map();
  Map<String, dynamic> recovered = Map();
  Map<String, dynamic> deaths = Map();

  void getAndSetData() async {
    Map<String, dynamic> histData =
        await apiData.getCountryHistoricalData('${widget.countryName}');
    setState(() {
      if (histData == null || widget.cases == null) {
        print('error Null data obtained');
        return;
      }

      cases = histData['timeline']['cases'];
      deaths = histData['timeline']['deaths'];

      // recovered = histData['timeline']['recovered'];// deprecated from API

      for (var i = 0; i < cases.length; i++) {
        final myData = IndiaHistoricalData(
          date: cases.keys.elementAt(i).toString(),
          cases: cases.values.elementAt(i),
          // recovered: recovered.values.elementAt(i), //deprecated
          deaths: deaths.values.elementAt(i),
        );
        countryData.add(myData);
      }

      // for testing
      // for (var data in countryData) {
      //   print('${data.date} : ${data.cases},${data.deaths}');
      // }

      _lineSeriesData.add(charts.Series(
          colorFn: (IndiaHistoricalData data, _) =>
              charts.Color.fromHex(code: '#c31432'),
          data: countryData,
          domainFn: (IndiaHistoricalData data, _) => data.cases,
          measureFn: (IndiaHistoricalData data, _) => data.deaths,
          id: 'DEATHS'));

      // _lineSeriesData.add(charts.Series(
      //     colorFn: (IndiaHistoricalData data, _) =>
      //         charts.Color.fromHex(code: '#0f9b0f'),
      //     data: countryData,
      //     domainFn: (IndiaHistoricalData data, _) => data.cases,
      //     measureFn: (IndiaHistoricalData data, _) => data.recovered,
      //     id: 'RECOVERED'));// deprecated
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(FontAwesomeIcons.chartPie)),
              Tab(icon: Icon(FontAwesomeIcons.chartLine)),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                    'Data Source: https://www.worldometers.info/coronavirus/',
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle,
                  ),
                ),
              ),
            ),
          ],
          title: Text('InfoGraphs'),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${widget.countryName ?? 'Country Name'}',
                        style: TextStyle(
                            fontSize: 34.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Cases: ${widget.cases ?? 'Country Cases'}',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber),
                      ),
                      Text(
                        'Deaths: ${widget.deaths ?? 'Country Deaths'}',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      Text(
                        'Recovered: ${widget.recovered ?? 'recovered'}',
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      SizedBox(height: 30),
                      PieChart(
                        dataMap: _dataMap,
                        animationDuration: Duration(milliseconds: 800),
                        chartLegendSpacing: 32.0,
                        chartRadius: MediaQuery.of(context).size.width / 1.5,
                        showChartValuesInPercentage: true,
                        showChartValues: true,
                        showChartValuesOutside: false,
                        chartValueBackgroundColor: Colors.grey[200],
                        colorList: [Colors.amber, Colors.red, Colors.green],
                        showLegends: true,
                        legendPosition: LegendPosition.top,
                        decimalPlaces: 1,
                        showChartValueLabel: true,
                        initialAngle: 0,
                        chartValueStyle: defaultChartValueStyle.copyWith(
                          color: Colors.blueGrey[900].withOpacity(0.9),
                        ),
                        chartType: ChartType.disc,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${widget.countryName ?? 'Country Name'}',
                        style: TextStyle(
                            fontSize: 34.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: charts.LineChart(_lineSeriesData,
                            defaultRenderer: charts.LineRendererConfig(
                              includeArea: true,
                              stacked: true,
                              roundEndCaps: true,
                              includePoints: true,
                              radiusPx: 2.5,
                              includeLine: true,
                              
                            ),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            behaviors: [
                              charts.ChartTitle(
                                'Number of Cases',
                                titleStyleSpec: charts.TextStyleSpec(
                                  fontFamily: 'google',
                                  color: charts.Color.fromHex(code: '#f7aa0f'),
                                ),
                                behaviorPosition:
                                    charts.BehaviorPosition.bottom,
                                titleOutsideJustification:
                                    charts.OutsideJustification.middleDrawArea,
                              ),
                              charts.ChartTitle(
                                'Number of Deaths',
                                titleStyleSpec: charts.TextStyleSpec(
                                  fontFamily: 'google',
                                  color: charts.Color.fromHex(code: '#c31432'),
                                ),
                                behaviorPosition: charts.BehaviorPosition.start,
                                titleOutsideJustification:
                                    charts.OutsideJustification.middleDrawArea,
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
