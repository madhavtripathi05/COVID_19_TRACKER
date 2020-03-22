import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';
import '../models/state_virus_data.dart';
import '../widgets/data_list_item.dart';

class StatesInfoScreen extends StatefulWidget {
  static const routeName = '/states-info-screen';

  final stateVirusData;
  StatesInfoScreen({this.stateVirusData});
  @override
  _StatesInfoScreenState createState() => _StatesInfoScreenState();
}

class _StatesInfoScreenState extends State<StatesInfoScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    updateStatesUI(widget.stateVirusData);
    super.initState();
  }

  StateVirusData locationData;
  List<StateVirusData> statesData = [];
  List<StateVirusData> statesForDisplay = [];

  Card buildCard(int index) {
    return Card(
      elevation: 7,
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            DataListItem(
                '${index + 1}.  ${statesForDisplay[index].stateName}  ',
                true,
                Colors.deepOrangeAccent),
            DataListItem(
                'Confirmed(Indians):${statesForDisplay[index].confirmedCases}',
                false,
                Colors.amber),
            DataListItem(
                'Confirmed(NRI): ${statesForDisplay[index].confirmedCasesNRI}',
                false,
                Colors.amberAccent),
            DataListItem('Recovered: ${statesForDisplay[index].recovered}',
                false, Colors.green),
            DataListItem(
                'Deaths: ${statesForDisplay[index].deaths}', false, Colors.red),
            // Details in Separate Widgets
          ],
        ),
      ),
    );
  }

  void updateStatesUI(dynamic virusData) {
    setState(() {
      if (virusData == null) {
        locationData = StateVirusData(
          confirmedCases: '0',
          confirmedCasesNRI: '0',
          deaths: '0',
          index: '0',
          recovered: '0',
          stateName: 'None',
        );
        return;
      }
      for (var eachData in virusData) {
        locationData = StateVirusData(
          confirmedCases: eachData['confirmedCases'] ?? '',
          confirmedCasesNRI: eachData['confirmedCasesNRI'] ?? '',
          deaths: eachData['deaths'] ?? '',
          index: eachData['index'] ?? '',
          recovered: eachData['recovered'] ?? '',
          stateName: eachData['stateName'] ?? '',
        );
        statesData.add(locationData);
      }
      statesForDisplay = statesData;
    });
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          labelText: 'Search States',
          hintText: 'Type Gujarat',
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            statesForDisplay = statesData.where((state) {
              var sName = state.stateName.toLowerCase();
              return sName.startsWith(text)||sName.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  Widget buildList() {
    return Expanded(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: statesForDisplay.length + 1,
        itemBuilder: (ctx, index) => SingleChildScrollView(
          child: index == 0 ? _searchBar() : buildCard(index - 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  'States of India',
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
                      action: SnackBarAction(
                          textColor: Colors.greenAccent,
                          label: 'Call Helpline',
                          onPressed: () => launch("tel://+91-11-23978046")),
                      content: Text(
                        'Data Source: https://www.mohfw.gov.in/\nHelpline Number for corona-virus : +91-11-23978046',
                        style: kNormalTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            buildList(),
          ],
        ),
      ),
      
    );
  }
}
