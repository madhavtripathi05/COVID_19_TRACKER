class CountryHistoricalData {
  String country = '';
  String date = '';
  int cases = 0;
  int deaths = 0;
  int recovered = 0;
}

class IndiaHistoricalData {
  String date = '';
  int cases = 0;
  int deaths = 0;
  int recovered = 0;

  IndiaHistoricalData({this.cases, this.date, this.deaths, this.recovered});
}
