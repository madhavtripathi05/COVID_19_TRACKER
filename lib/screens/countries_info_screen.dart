import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/country_virus_data.dart';
import '../widgets/data_list_item.dart';

class CountriesInfoScreen extends StatefulWidget {
  static const routeName = '/countries-info-screen';

  final countryVirusData;
  CountriesInfoScreen({this.countryVirusData});
  @override
  CountriesInfoScreenState createState() => CountriesInfoScreenState();
}

class CountriesInfoScreenState extends State<CountriesInfoScreen> {
  CountryVirusData locationData;
  List<CountryVirusData> countriesData = [];
  List<CountryVirusData> countriesForDisplay = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    updateCountriesUI(widget.countryVirusData);
    super.initState();
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
      countriesForDisplay = countriesData;
    });
  }

  Widget buildList() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: countriesForDisplay.length + 1,
        itemBuilder: (ctx, index) => index == 0
            ? _searchBar()
            : SingleChildScrollView(
                child: buildCard(index - 1),
              ),
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          labelText: 'Search Countries',
          hintText: 'Type India',
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            countriesForDisplay = countriesData.where((c) {
              var cName = c.country.toLowerCase();
              return cName.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  Card buildCard(int index) {
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            DataListItem(
                '${index + 1}.  ${countriesForDisplay[index].country}  ',
                true,
                Colors.deepOrangeAccent),
            DataListItem(
                'Confirmed: ${countriesForDisplay[index].confirmedCases}',
                false,
                Colors.amber),
            DataListItem('Recovered: ${countriesForDisplay[index].recovered}',
                false, Colors.green),
            DataListItem('Deaths: ${countriesForDisplay[index].deaths}', false,
                Colors.red),
            DataListItem(
                'Critical Cases ${countriesForDisplay[index].criticalCases}',
                false,
                Colors.teal),
            DataListItem(
                'Today\'s Cases: ${countriesForDisplay[index].todayCases}',
                false,
                Colors.lightBlueAccent),
            DataListItem(
                'Today\'s Deaths: ${countriesForDisplay[index].todayDeaths}',
                false,
                Colors.redAccent),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(title: Text('All Countries'), centerTitle: true),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context)),
                Text(
                  'All Countries',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.blueAccent),
                ),
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
            ),
            // SizedBox(height: 50),

            buildList(),
          ],
        ),
      ),
    );
  }
}
