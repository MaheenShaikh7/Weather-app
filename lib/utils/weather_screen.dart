import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/utils/additional_info.dart';
import 'package:weather_app/utils/hourly_forecast_card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  String cityName = 'London';
  double currentTemp = 0;
  String currentSkyConditions = '';
  int currentHumdity = 0;
  int currentPressure = 0;
  double currentWindSpeed = 0;

  List<String> hour = [];
  List<double> temp = [];

  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    try {
      String apiKey = 'fa7db1afbaa9ca62aeabe13791203a9e';

      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey'));

      final hourlyResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey'));

      if (response.statusCode == 200 && hourlyResponse.statusCode == 200) {
        final data = jsonDecode(response.body);
        // print(data);

        setState(() {
          isLoading = false;
          currentTemp = data['main']['temp'] - 273.15;
          currentSkyConditions = data['weather'][0]['main'];
          currentWindSpeed = data['wind']['speed'];
          currentHumdity = data['main']['humidity'];
          currentPressure = data['main']['pressure'];
        });

        final hourlyData = jsonDecode(hourlyResponse.body);
        // print(data);

        for (int i = 0; i < 8; i++) {
          setState(() {
            hour.add(hourlyData['list'][i]['dt_txt']);
            temp.add(hourlyData['list'][i]['main']['temp'] - 273.15);
          });
        }
      } else {
        print('Error : ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
            cityName[0].toUpperCase() + cityName.substring(1).toLowerCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                getCurrentWeather();
                // print('Refresh');
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.black,
              ))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    child: Column(
                      children: [
                        Text(
                          '${currentTemp.toStringAsFixed(2)} C',
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          currentSkyConditions == 'Clouds' ||
                                  currentSkyConditions == 'Mist' ||
                                  currentSkyConditions == 'Rains'
                              ? Icons.cloud
                              : Icons.wb_sunny,
                          size: 64,
                          color: currentSkyConditions == 'Clouds' ||
                                  currentSkyConditions == 'Mist' ||
                                  currentSkyConditions == 'Rains'
                              ? Colors.blueGrey
                              : Colors.orange,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          currentSkyConditions,
                          style: const TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hourly Forecast",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HourlyForecastCard(
                          hour: hour[0].substring(11, 16),
                          icon: ((isItday(hour[0]))),
                          temp: '${temp[0].toStringAsFixed(2)} C'),
                      HourlyForecastCard(
                          hour: hour[1].substring(11, 16),
                          icon: (isItday(hour[1])),
                          temp: '${temp[1].toStringAsFixed(2)} C'),
                      HourlyForecastCard(
                          hour: hour[2].substring(11, 16),
                          icon: (isItday(hour[2])),
                          temp: '${temp[2].toStringAsFixed(2)} C'),
                      HourlyForecastCard(
                          hour: hour[3].substring(11, 16),
                          icon: (isItday(hour[3])),
                          temp: '${temp[3].toStringAsFixed(2)} C'),
                      HourlyForecastCard(
                          hour: hour[4].substring(11, 16),
                          icon: (isItday(hour[4])),
                          temp: '${temp[4].toStringAsFixed(2)} C'),
                      HourlyForecastCard(
                          hour: hour[5].substring(11, 16),
                          icon: (isItday(hour[5])),
                          temp: '${temp[5].toStringAsFixed(2)} C'),
                      HourlyForecastCard(
                          hour: hour[6].substring(11, 16),
                          icon: (isItday(hour[6])),
                          temp: '${temp[6].toStringAsFixed(2)} C'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Additional Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalInfo(
                      title: 'Wind',
                      value: '$currentWindSpeed km/h',
                      icon: Icons.air,
                    ),
                    AdditionalInfo(
                      title: 'Humidity',
                      value: '$currentHumdity %',
                      icon: Icons.water,
                    ),
                    AdditionalInfo(
                      title: 'Pressure',
                      value: '$currentPressure hPa',
                      icon: Icons.arrow_downward,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Change Location'),
                              content: TextField(
                                controller: cityController,
                                decoration: const InputDecoration(
                                    hintText: 'Enter City Name'),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[a-zA-z]'))
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('cancel')),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        cityName = cityController.text;
                                        isLoading = true;
                                      });
                                      getCurrentWeather();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          });
                    },
                    child: const Text(
                      'Change Location',
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ]),
            ),
    );
  }

  IconData isItday(String hour) {
    IconData icon;
    int.parse(hour.substring(11, 13)) >= 7 &&
            int.parse(hour.substring(11, 13)) <= 19
        ? icon = Icons.wb_sunny
        : icon = Icons.nightlight;

    return icon;
  }
}
