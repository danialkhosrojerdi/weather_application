import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_application/Model/current_city_data_model.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<CurrentCityDataModel> currentCityDataModel;

  TextEditingController textEditingController = TextEditingController();
  String cityName = 'london';
  String? lat;
  String? lon;

  @override
  void initState() {
    currentCityDataModel = sendApiRequestForCurrentWeather(cityName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
          ),
          elevation: 0,
          actions: <Widget>[
            PopupMenuButton<String>(
              itemBuilder: (context) {
                return {'Setting', 'Profile', 'Logout'}.map((String choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: currentCityDataModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              CurrentCityDataModel? cityDataModel =
                  snapshot.data as CurrentCityDataModel?;

              final formatter = DateFormat.jm();
              var sunrise = formatter.format(
                DateTime.fromMillisecondsSinceEpoch(
                  cityDataModel!.sunrise * 1000,
                  isUtc: true,
                ),
              );

              var sunset = formatter.format(
                DateTime.fromMillisecondsSinceEpoch(
                  cityDataModel.sunset * 1000,
                  isUtc: true,
                ),
              );

              return Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 2,
                    sigmaY: 2,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: textEditingController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter City Name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Find'),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          cityDataModel.cityName,
                          style: const TextStyle(
                              fontSize: 30, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          cityDataModel.description,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 36),
                        child: setWeatherIcon(cityDataModel),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          '${cityDataModel.temp}' '\u00b0',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  const Text(
                                    'Max',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${cityDataModel.tempMax}' '\u00b0',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                children: [
                                  const Text(
                                    'Min',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      '${cityDataModel.tempMin}' '\u00b0',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.grey[900],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 6,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: 70,
                                height: 80,
                                child: Column(
                                  children: const [
                                    Text(
                                      'Fri, 8pm',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Icon(
                                        Icons.sunny_snowing,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        '14' '\u00b0',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey[900],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Wind Speed',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '${cityDataModel.windSpeed}' ' m/s',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            child: Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Sunrise',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  sunrise,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            child: Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Sunset',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  sunset,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 10, right: 10),
                            child: Container(
                              width: 1,
                              height: 30,
                              color: Colors.grey,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  'Humidity',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  '${cityDataModel.humidity}' ' %',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Image setWeatherIcon(model) {
    String description = model.description;
    if (description == 'clear sky') {
      return const Image(image: AssetImage('assets/images/sun.png'));
    } else if (description == 'few clouds') {
      return const Image(image: AssetImage('assets/images/partly-cloudy.png'));
    } else if (description.contains('clouds')) {
      return const Image(image: AssetImage('assets/images/clouds.png'));
    } else if (description.contains('thunderstorm')) {
      return const Image(image: AssetImage('assets/images/storm.png'));
    } else if (description.contains('drizzle')) {
      return const Image(image: AssetImage('assets/images/rain-cloud.png'));
    } else if (description.contains('rain')) {
      return const Image(image: AssetImage('assets/images/heavy-rain.png'));
    } else if (description.contains('snow')) {
      return const Image(image: AssetImage('assets/images/snow.png'));
    } else {
      return const Image(image: AssetImage('assets/images/windy-weather.png'));
    }
  }

  Future<CurrentCityDataModel> sendApiRequestForCurrentWeather(
      String cityName) async {
    String apiKey = 'aa0322c4d8f25cc2cfeace4fc8629222';

    var respose = await Dio().get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {'q': cityName, 'appid': apiKey, 'units': 'metric'},
    );

    lon = respose.data['coord']['lon'];
    lat = respose.data['coord']['lat'];

    var dataModel = CurrentCityDataModel(
      cityName: respose.data['name'],
      lon: respose.data['coord']['lon'],
      lat: respose.data['coord']['lat'],
      main: respose.data['weather'][0]['main'],
      description: respose.data['weather'][0]['description'],
      temp: respose.data['main']['temp'],
      tempMin: respose.data['main']['temp_min'],
      tempMax: respose.data['main']['temp_max'],
      pressure: respose.data['main']['pressure'],
      humidity: respose.data['main']['humidity'],
      windSpeed: respose.data['wind']['speed'],
      dataTime: respose.data['dt'],
      country: respose.data['sys']['country'],
      sunrise: respose.data['sys']['sunrise'],
      sunset: respose.data['sys']['sunset'],
    );

    return dataModel;
  }
}
