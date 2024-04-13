import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final String weather;
  final String location;

  WeatherData({required this.temperature, required this.weather, required this.location});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      weather: json['weather'][0]['description'],
      location: json['name'],
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String _cityName;
  late WeatherData _weatherData = WeatherData(temperature: 0, weather: '', location: '');
  late List<WeatherData> _weatherList = [];
  late List<String> _searchedCities = [];
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Kota'),
        backgroundColor: Colors.blue.withOpacity(0.8),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('Edit Daftar'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('Pemberitahuan'),
                  value: 'pemberitahuan',
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Text('Tampilkan dalam '),
                      Text('°C', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(' / '),
                      Text('°F', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  value: 'suhu',
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editCitiesList();
                  break;
                case 'pemberitahuan':
                  // Tambahkan kode untuk aksi pemberitahuan
                  break;
                case 'suhu':
                  // Tambahkan kode untuk aksi tampilkan suhu
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan nama kota',
                ),
                onChanged: (value) {
                  _cityName = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _fetchWeatherData();
                },
                child: const Text('Cari'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _weatherList.length,
                itemBuilder: (context, index) {
                  return buildWeatherCard(_weatherList[index]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchWeatherData() async {
    const apiKey = 'f10ee4660fa58303265395b50c248816';
    final url = 'http://api.openweathermap.org/data/2.5/weather?q=$_cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    final jsonData = json.decode(response.body);
    setState(() {
      _weatherData = WeatherData.fromJson(jsonData);
      _weatherList.add(_weatherData);
      _searchedCities.add(_cityName);
    });
  }

  Widget buildWeatherCard(WeatherData weatherData) {
  Color? cardColor = Colors.white; // Default color
  IconData weatherIcon = Icons.cloud; // Default icon
  if (weatherData.weather.toLowerCase().contains('rain')) {
    cardColor = Colors.blueGrey; // Set color to blueGrey if it's raining
    weatherIcon = Icons.beach_access; // Set icon to beach_access if it's raining
  } else if (weatherData.weather.toLowerCase().contains('clear')) {
    cardColor = Colors.orangeAccent; // Set color to orangeAccent if it's clear
    weatherIcon = Icons.wb_sunny; // Set icon to wb_sunny if it's clear
  }

  return Card(
    color: cardColor,
    elevation: 5.0,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                weatherIcon,
                size: 40.0,
                color: Colors.black,
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            'Suhu: ${weatherData.temperature.toStringAsFixed(1)}°C',
            style: const TextStyle(fontSize: 24.0),
            textAlign: TextAlign.center,
          ),
          Text(
            '${weatherData.weather}',
            style: const TextStyle(fontSize: 24.0),
            textAlign: TextAlign.center,
          ),
          Text(
            'Lokasi: ${weatherData.location}',
            style: const TextStyle(fontSize: 24.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          Positioned(
          top: 0,
          right: 20,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                _weatherList.remove(weatherData);
                _searchedCities.remove(weatherData.location);
                });
              },
            ),
           ),
        ],
      ),
    ),
  );
}

  void _editCitiesList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Daftar Kota'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _searchedCities
                  .map((city) => ListTile(
                        title: Text(city),
                        onTap: () {
                          // Tambahkan kode untuk mengedit kota yang dicari
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
