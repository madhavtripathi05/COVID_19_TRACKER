class CountryVirusData {
  String country = '';
  int confirmedCases = 0;
  int criticalCases = 0;
  int deaths = 0;
  int recovered = 0;
  int todayCases = 0;
  int todayDeaths = 0;

  CountryVirusData(
      {this.confirmedCases,
      this.country,
      this.deaths,
      this.recovered,
      this.criticalCases,
      this.todayCases,
      this.todayDeaths});
}
