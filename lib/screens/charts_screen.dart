import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartsScreen extends StatefulWidget {
  static const routeName = '/charts';

  final seriesList;
  ChartsScreen({this.seriesList});

  factory ChartsScreen.withSampleData() =>
      ChartsScreen(seriesList: _createSampleData());

  static List<charts.Series<Country, int>> _createSampleData() {
    final data = [
      new Country(0, 100),
      new Country(1, 75),
      new Country(2, 25),
      new Country(3, 5),
    ];

    return [
      new charts.Series<Country, int>(
        id: 'Sales',
        domainFn: (Country con, _) => con.month,
        measureFn: (Country con, _) => con.deaths,
        data: data,
      )
    ];
  }

  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: charts.PieChart([],
              animate: true,
              // Configure the width of the pie slices to 60px. The remaining space in
              // the chart will be left as a hole in the center.
              defaultRenderer: charts.ArcRendererConfig(arcWidth: 60)),
        ),
      ),
    );
  }
}

class Country {
  final int month;
  final int deaths;

  Country(this.month, this.deaths);
}
