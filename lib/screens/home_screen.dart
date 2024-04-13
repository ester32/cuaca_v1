// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:ui';
import 'package:cuaca_v1/screens/latihan_crud.dart';
import 'package:cuaca_v1/screens/news_screen.dart';
import 'package:cuaca_v1/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_icons/weather_icons.dart';
import 'package:cuaca_v1/screens/profile_screen.dart';


class HomeScreen extends StatefulWidget {
  final String defaultCity;

  const HomeScreen({Key? key, this.defaultCity = 'Singaraja'}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WeatherData _weatherData = WeatherData(temperature: 0, weather: '');
  final String appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    const apiKey = 'f10ee4660fa58303265395b50c248816';
    final url ='http://api.openweathermap.org/data/2.5/weather?q=${widget.defaultCity}&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _weatherData = WeatherData.fromJson(jsonData);
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  Future<void> _refreshWeatherData() async {
    await _fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.blue.withOpacity(0.8), // Gradient color for appbar
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWeatherData,
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue, Colors.lightBlueAccent], // Gradient color for background
                ),
              ),
              child: Center(
                child: Card(
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(_getWeatherIcon(_weatherData.weather), size: 100.0, color: Color.fromARGB(255, 89, 178, 230)),
                        SizedBox(height: 10.0),
                        Text(
                          'Suhu: ${_weatherData.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          '${_weatherData.weather}',
                          style: const TextStyle(fontSize: 24.0),
                        ),
                        Text(
                          'Lokasi: ${widget.defaultCity}',
                          style: const TextStyle(fontSize: 24.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.lightBlueAccent,Colors.blue,],
              ),
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                List.generate(7, (index) {
                  final dayOfWeek = DateTime.now().add(Duration(days: index)).weekday;
                  String dayName = '';
                  switch (dayOfWeek) {
                    case DateTime.monday:
                      dayName = 'Senin';
                      break;
                    case DateTime.tuesday:
                      dayName = 'Selasa';
                      break;
                    case DateTime.wednesday:
                      dayName = 'Rabu';
                      break;
                    case DateTime.thursday:
                      dayName = 'Kamis';
                      break;
                    case DateTime.friday:
                      dayName = 'Jumat';
                      break;
                    case DateTime.saturday:
                      dayName = 'Sabtu';
                      break;
                    case DateTime.sunday:
                      dayName = 'Minggu';
                      break;
                  }
                  final weather = _weatherData.weather;
                  final temperature = _weatherData.temperature.round();
                  return ListTile(
                    title: Text(dayName),
                    subtitle: Text('Data Cuaca'),
                    leading: Icon(Icons.wb_sunny),
                    trailing: Text('$temperature°C'),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Color.fromARGB(255, 11, 92, 129)], // Gradient color for drawer background
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Acrylic effect for drawer
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuaca',
                        style: TextStyle(fontSize: 24.0, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        'Versi $appVersion',
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                
                ListTile(
                  title: Text(
                    'Profile',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Mengatur warna teks menjadi hitam
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    'Tentang Saya',
                    style: TextStyle(color: Colors.white), // Mengatur warna teks menjadi hitam
                  ),
                  onTap: () {
                    _showDeveloperInfoDialog(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'News',
                    style: TextStyle(color: Colors.white), // Mengatur warna teks menjadi hitam
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Latihan CRUD',
                    style: TextStyle(color: Colors.white), // Mengatur warna teks menjadi hitam
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LatihanCRUD(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Pencarian',
          ),
        ],
        selectedItemColor: Colors.black,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          }
        },
        backgroundColor: Color.fromARGB(255, 136, 188, 231).withOpacity(0.8), // Gradient color for bottom navigation
      ),
    );
  }

  IconData _getWeatherIcon(String weather) {
    switch (weather) {
      case 'Clear':
        return WeatherIcons.day_sunny;
      case 'Clouds':
        return WeatherIcons.cloudy;
      case 'Rain':
        return WeatherIcons.rain;
      case 'Thunderstorm':
        return WeatherIcons.thunderstorm;
      case 'Snow':
        return WeatherIcons.snow;
      default:
        return WeatherIcons.na;
    }
  }

  void _showDeveloperInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tentang Pengembang'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nama: Ester Florida'),
                Text('Email: ester@example.com'),
                Text('No. Telepon: 08123456789'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

class WeatherData {
  final double temperature;
  final String weather;

  WeatherData({
    required this.temperature,
    required this.weather,
  });

  factory WeatherData.fromJson(Map<String  , dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'],
      weather: json['weather'][0]['main'],
    );
  }
}
