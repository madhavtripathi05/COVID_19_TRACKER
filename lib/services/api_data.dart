import 'package:flutter/foundation.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoder/geocoder.dart';

import '../services/network_api.dart';
import 'location_data.dart';

class ApiData {
  Future<dynamic> getVirusData() async {
    //fetching data from API
    NetworkAPI networkAPI = NetworkAPI('https://corona.lmao.ninja/v2/all');
    var virusData = networkAPI.getData();
    // print(virusData.toString());
    return virusData;
  }

  Future<dynamic> getLocationVirusData() async {
    //getting location
    MyLocationData location = MyLocationData();
    final position = await location.getLocationData();
    final coordinates = new Coordinates(position.latitude, position.longitude);
    String country = 'IN';
    if (!kIsWeb) {
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      country = addresses.first.countryCode;
    }
    //fetching data from API
    NetworkAPI networkAPI = NetworkAPI(
        'https://corona.lmao.ninja/v2/countries/${country.toLowerCase()}');
    var locationVirusData = networkAPI.getData();
    // print(locationVirusData.toString());
    return locationVirusData;
  }

  Future<dynamic> getCountriesVirusData() async {
    //fetching data from API
    NetworkAPI networkAPI = NetworkAPI(
        'https://corona.lmao.ninja/v2/countries?yesterday=false&sort=cases');
    var countriesVirusData = networkAPI.getData();
    // print(countriesVirusData.toString());
    return countriesVirusData;
  }

  Future<dynamic> getCountryHistoricalData(String country) async {
    //fetching data from API
    NetworkAPI networkAPI = NetworkAPI(
        'https://corona.lmao.ninja/v3/covid-19/historical/$country?lastdays=all');
    var indiaHistoricalData = networkAPI.getData();
    // print(indiaHistoricalData.toString());
    return indiaHistoricalData;
  }

  Future<dynamic> getWorldHistoricalData() async {
    //fetching data from API
    NetworkAPI networkAPI =
        // NetworkAPI('https://corona.lmao.ninja/v2/historical/all');
        NetworkAPI('https://corona.lmao.ninja/v3/covid-19/historical/all');
    var allHistoricalData = networkAPI.getData();
    // print(allHistoricalData.toString());
    return allHistoricalData;
  }

  Future<dynamic> getStatesData() async {
    //fetching data from API
    NetworkAPI networkAPI =
        NetworkAPI('https://api.rootnet.in/covid19-in/stats/latest');
    var allHistoricalData = networkAPI.getData();
    // print(allHistoricalData.toString());
    return allHistoricalData;
  }
}
