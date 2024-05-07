import 'package:flutter/material.dart';
import 'package:havadurumu/models/weather_models.dart';
import 'package:havadurumu/services/weather_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WeatherModel> _weathers = [];

  void _getWeatherData() async {
    _weathers = await WeatherServices().getWeatherData();
    setState(() {});
  }

  @override
  void initState() {
    _getWeatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hava Durumu'),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: _weathers.length,
        itemBuilder: (context, index) {
          final WeatherModel weather = _weathers[index];
          return Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Image.network(
                  weather.ikon,
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 25),
                  child: Text(
                    "${weather.gun}\n ${weather.durum.toUpperCase()} ${weather.derece} °",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Min: ${weather.min} °"),
                        Text("Max: ${weather.max} °"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Gece: ${weather.gece} °"),
                        Text("Nem oranı: ${weather.nem}"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
