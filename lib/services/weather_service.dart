// lib/services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmiq_app/models/weather.dart';

class WeatherService {
  final String _baseUrl = 'http://10.0.2.2:3000/api';
  // You should hide your API keys, but for this example, we'll use it directly
  final String _openWeatherApiKey = '9c13f42072dbbf25d332b0dde6c11f4b';

  Future<Weather> getWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('userLat') ?? 28.5355; // Default to Noida
    final lon = prefs.getDouble('userLon') ?? 77.3910; // Default to Noida

    // Fetch weather data from your server
    final weatherResponse = await http.get(Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon'));

    if (weatherResponse.statusCode == 200) {
      final weatherData = json.decode(weatherResponse.body);

      // Fetch location name from OpenWeather's reverse geocoding API
      final geoResponse = await http.get(Uri.parse('https://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$_openWeatherApiKey'));

      String locationName = 'Unknown';
      if (geoResponse.statusCode == 200) {
        final geoData = json.decode(geoResponse.body);
        if (geoData.isNotEmpty) {
          locationName = geoData[0]['name'] ?? 'Unknown';
        }
      }

      return Weather.fromJson(weatherData, locationName);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}