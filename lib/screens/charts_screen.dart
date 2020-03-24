import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_19_tracker/services/api_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/country_historical_data.dart';

class ChartsScreen extends StatefulWidget {
  static const routeName = '/charts';
  final String countryName;
  ChartsScreen({this.countryName});
  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  ApiData apiData = ApiData();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<IndiaHistoricalData> indiaData = [];
  // List<charts.Series<IndiaHistoricalData, String>> _pieSeriesData = [];
  // List<charts.Series<IndiaHistoricalData, String>> _seriesData = [];
  List<charts.Series<IndiaHistoricalData, int>> _lineSeriesData = [];
  @override
  void initState() {
    getAndSetData();
    super.initState();
  }

  void getAndSetData() async {
    Map<String, dynamic> histData = await apiData.getIndiaHistoricalData();
    setState(() {
      if (histData == null) {
        print('error Null data obtained');
        return;
      }
      Map<String, dynamic> cases = histData['timeline']['cases'];
      Map<String, dynamic> recovered = histData['timeline']['recovered'];
      Map<String, dynamic> deaths = histData['timeline']['deaths'];

      for (var i = 0; i < cases.length; i++) {
        final myData = IndiaHistoricalData(
          date: cases.keys.elementAt(i).toString(),
          cases: cases.values.elementAt(i) ?? 0,
          recovered: recovered.values.elementAt(i) ?? 0,
          deaths: deaths.values.elementAt(i) ?? 0,
        );
        indiaData.add(myData);
      }

      // for (var data in indiaData) {
      //   print('${data.date} : ${data.cases},${data.deaths},${data.recovered}');
      // }
      // _pieSeriesData.add(charts.Series(
      //   data: indiaData,
      //   id: 'indiaData',
      //   domainFn: (IndiaHistoricalData data, _) => data.cases.toString(),
      //   measureFn: (IndiaHistoricalData data, _) => data.deaths,
      // ));

      _lineSeriesData.add(charts.Series(
          data: indiaData,
          domainFn: (IndiaHistoricalData data, _) => data.cases,
          measureFn: (IndiaHistoricalData data, _) => data.deaths,
          id: 'deaths'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Color(0xff1976d2),
          //backgroundColor: Color(0xff308e1c),
          bottom: TabBar(
            indicatorColor: Color(0xff9962D0),
            tabs: [
              // Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
              // Tab(icon: Icon(FontAwesomeIcons.chartPie)),
              Tab(icon: Icon(FontAwesomeIcons.chartLine)),
            ],
          ),
          title: Text('Flutter Charts'),
        ),
        body: TabBarView(
          children: [
            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Container(
            //     child: Center(
            //       child: Column(
            //         children: <Widget>[
            //           Text(
            //             'SO₂ emissions, by world region (in million tonnes)',
            //             style: TextStyle(
            //                 fontSize: 24.0, fontWeight: FontWeight.bold),
            //           ),
            //           Expanded(
            //             child: charts.BarChart(
            //               _pieSeriesData,
            //               animate: true,
            //               barGroupingType: charts.BarGroupingType.grouped,
            //               //behaviors: [  charts.SeriesLegend()],
            //               animationDuration: Duration(seconds: 5),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Container(
            //     child: Center(
            //       child: Column(
            //         children: <Widget>[
            //           Text(
            //             'Time spent on daily tasks',
            //             style: TextStyle(
            //                 fontSize: 24.0, fontWeight: FontWeight.bold),
            //           ),
            //           SizedBox(
            //             height: 10.0,
            //           ),
            //           Expanded(
            //             child: charts.PieChart(
            //               _pieSeriesData,
            //               animate: true,
            //               animationDuration: Duration(seconds: 5),
            //               behaviors: [
            //                   charts.DatumLegend(
            //                   outsideJustification:
            //                       charts.OutsideJustification.endDrawArea,
            //                   horizontalFirst: false,
            //                   desiredMaxRows: 2,
            //                   cellPadding:
            //                         EdgeInsets.only(right: 4.0, bottom: 4.0),
            //                   entryTextStyle: charts.TextStyleSpec(
            //                       color: charts
            //                           .MaterialPalette.purple.shadeDefault,
            //                       fontFamily: 'Georgia',
            //                       fontSize: 11),
            //                 )
            //               ],
            //               defaultRenderer:   charts.ArcRendererConfig(
            //                 arcWidth: 100,
            //                 arcRendererDecorators: [
            //                     charts.ArcLabelDecorator(
            //                       labelPosition: charts.ArcLabelPosition.inside)
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'cases/deaths',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: charts.LineChart(_lineSeriesData,
                            defaultRenderer: charts.LineRendererConfig(
                                includeArea: true, stacked: true),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            behaviors: [
                              charts.ChartTitle('CASES',
                                  behaviorPosition:
                                      charts.BehaviorPosition.bottom,
                                  titleOutsideJustification: charts
                                      .OutsideJustification.middleDrawArea),
                              charts.ChartTitle('DEATHS',
                                  behaviorPosition:
                                      charts.BehaviorPosition.start,
                                  titleOutsideJustification: charts
                                      .OutsideJustification.middleDrawArea),
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
