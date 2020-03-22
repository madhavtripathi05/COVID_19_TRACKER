import '../services/location_data.dart';
import '../services/network_api.dart';

class ApiData {
  Future<dynamic> getVirusData() async {
    //fetching data from API
    NetworkAPI networkAPI = NetworkAPI('https://corona.lmao.ninja/all');
    var virusData = networkAPI.getData();
    print(virusData.toString());
    return virusData;
  }

  Future<dynamic> getLocationVirusData() async {
    //getting location
    LocationData location = LocationData();
    await location.getLocationData();
    String country = location.country;
    //fetching data from API
    NetworkAPI networkAPI = NetworkAPI(
        'https://corona.lmao.ninja/countries/${country.toLowerCase()}');
    var locationVirusData = networkAPI.getData();
    print(locationVirusData.toString());
    return locationVirusData;
  }

  Future<dynamic> getCountriesVirusData() async {
    //fetching data from API
    NetworkAPI networkAPI = NetworkAPI('https://corona.lmao.ninja/countries');
    var countriesVirusData = networkAPI.getData();
    print(countriesVirusData.toString());
    return countriesVirusData;
  }
}
