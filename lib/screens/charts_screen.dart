// ignore: import_of_legacy_library_into_null_safe
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

import '../services/api_data.dart';
import '../constants/constants.dart';
import '../models/historical_data.dart';

class ChartsScreen extends StatefulWidget {
  static const routeName = '/charts';
  final String countryName;
  final double cases;
  final double deaths;
  final double recovered;
  ChartsScreen(
      {required this.countryName,
      required this.cases,
      required this.deaths,
      required this.recovered});
  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  bool isLoading = false;
  @override
  void initState() {
    getAndSetData();

    _dataMap.putIfAbsent('cases', () => widget.cases);
    _dataMap.putIfAbsent('deaths', () => widget.deaths);
    _dataMap.putIfAbsent('recovered', () => widget.recovered);
    super.initState();
  }

  ApiData apiData = ApiData();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<HistoricalData> countryData = [];
  List<charts.Series<HistoricalData, int>> _lineSeriesDataDeaths = [];
  List<charts.Series<HistoricalData, int>> _lineSeriesDataRecovered = [];
  Map<String, double> _dataMap = Map();

  Map<String, dynamic> cases = Map();
  Map<String, dynamic> recovered = Map();
  Map<String, dynamic> deaths = Map();

  void getAndSetData() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> histData = widget.countryName == 'world'
        ? await apiData.getWorldHistoricalData()
        : await apiData.getCountryHistoricalData('${widget.countryName}');
    setState(() {
      // ignore: unnecessary_null_comparison
      if (histData == null) {
        print('error Null data obtained');
        return;
      }

      if (widget.countryName == 'world') {
        cases = histData['cases'];
        deaths = histData['deaths'];
        recovered = histData['recovered'];

        for (var i = 0; i < cases.length; i++) {
          final myData = HistoricalData(
            date: cases.keys.elementAt(i).toString(),
            cases: cases.values.elementAt(i),
            deaths: deaths.values.elementAt(i),
            recovered: recovered.values.elementAt(i),
          );
          countryData.add(myData);
        }
        return;
      }

      cases = histData['timeline']['cases'];
      deaths = histData['timeline']['deaths'];
      recovered = histData['timeline']['recovered'];

      for (var i = 0; i < cases.length; i++) {
        final myData = HistoricalData(
          date: cases.keys.elementAt(i).toString(),
          cases: cases.values.elementAt(i),
          deaths: deaths.values.elementAt(i),
          recovered: recovered.values.elementAt(i),
        );
        countryData.add(myData);
      }

      _lineSeriesDataDeaths.add(charts.Series(
          colorFn: (HistoricalData data, _) =>
              charts.Color.fromHex(code: '#c31432'),
          data: countryData,
          domainFn: (HistoricalData data, _) => data.cases,
          measureFn: (HistoricalData data, _) => data.deaths,
          id: 'DEATHS'));

      _lineSeriesDataRecovered.add(charts.Series(
          colorFn: (HistoricalData data, _) =>
              charts.Color.fromHex(code: '#0f9b0f'),
          data: countryData,
          domainFn: (HistoricalData data, _) => data.cases,
          measureFn: (HistoricalData data, _) => data.recovered,
          id: 'RECOVERED'));
    });
    setState(() {
      isLoading = false;
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
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
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
        body: Center(
          child: TabBarView(
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator.adaptive())
                  : Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Text(
                              '${widget.countryName.toUpperCase()}',
                              style: TextStyle(
                                  fontSize: 34.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent),
                            ),
                            SizedBox(height: 30),
                            Text(
                              'Cases: ${widget.cases.toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber),
                            ),
                            Text(
                              'Deaths: ${widget.deaths.toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            Text(
                              'Recovered: ${widget.recovered.toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: 400,
                              child: PieChart(
                                dataMap: _dataMap,
                                animationDuration: Duration(milliseconds: 800),
                                chartLegendSpacing: 32.0,
                                chartValuesOptions: ChartValuesOptions(
                                    showChartValuesInPercentage: true),
                                chartRadius:
                                    MediaQuery.of(context).size.width / 1.5,
                                colorList: [
                                  Colors.amber,
                                  Colors.red,
                                  Colors.green
                                ],
                                chartType: ChartType.disc,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              isLoading
                  ? Center(child: CircularProgressIndicator.adaptive())
                  : Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Text(
                                '${widget.countryName.toUpperCase()}',
                                style: TextStyle(
                                    fontSize: 34.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrangeAccent),
                              ),
                              SizedBox(height: 20),
                              Expanded(
                                child: charts.LineChart(
                                    _lineSeriesDataRecovered,
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
                                        'Number of people recovered',
                                        titleStyleSpec: charts.TextStyleSpec(
                                          fontFamily: 'google',
                                          color: charts.Color.fromHex(
                                              code: '#0f9b0f'),
                                        ),
                                        behaviorPosition:
                                            charts.BehaviorPosition.start,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea,
                                      ),
                                    ]),
                              ),
                              Expanded(
                                child: charts.LineChart(_lineSeriesDataDeaths,
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
                                          color: charts.Color.fromHex(
                                              code: '#f7aa0f'),
                                        ),
                                        behaviorPosition:
                                            charts.BehaviorPosition.bottom,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea,
                                      ),
                                      charts.ChartTitle(
                                        'Number of Deaths',
                                        titleStyleSpec: charts.TextStyleSpec(
                                          fontFamily: 'google',
                                          color: charts.Color.fromHex(
                                              code: '#c31432'),
                                        ),
                                        behaviorPosition:
                                            charts.BehaviorPosition.start,
                                        titleOutsideJustification: charts
                                            .OutsideJustification
                                            .middleDrawArea,
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
      ),
    );
  }
}
