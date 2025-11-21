import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../../core/config/env.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final position = await _determinePosition();
      final response = await http.get(Uri.parse(
          '$_baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${Env.openWeatherApiKey}&units=metric'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error getting weather: $e');
    }
  }

  Future<Map<String, dynamic>> getForecast() async {
    try {
      final position = await _determinePosition();
      // Using the 5 day / 3 hour forecast API as it's the standard free one.
      // One Call API requires a separate subscription even for free tier.
      // We will try to process this to look like daily forecast or just show the 3-hour intervals.
      // For "7 days", we really need One Call, but let's stick to the standard 'forecast' endpoint first
      // which gives 5 days. If the user key supports One Call, we could switch.
      // Let's try to get the standard forecast first.
      final response = await http.get(Uri.parse(
          '$_baseUrl/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=${Env.openWeatherApiKey}&units=metric'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error getting forecast: $e');
    }
  }
}
