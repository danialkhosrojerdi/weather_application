class CurrentCityDataModel {
  String cityName;
  double lon;
  double lat;
  String main;
  String description;
  double temp;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;
  double windSpeed;
  int dataTime;
  String country;
  int sunrise;
  int sunset;

  CurrentCityDataModel({
    required this.cityName,
    required this.lon,
    required this.lat,
    required this.main,
    required this.description,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.dataTime,
    required this.country,
    required this.sunrise,
    required this.sunset,
  });
}
