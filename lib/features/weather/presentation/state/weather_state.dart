import 'dart:async';
import 'package:signals_flutter/signals_flutter.dart';
import '../../data/weather_service.dart';

class WeatherState {
  static final _service = WeatherService();

  // State signals
  static final currentWeather = signal<Map<String, dynamic>?>(null);
  static final forecast = signal<Map<String, dynamic>?>(null);
  static final isLoading = signal(true);
  static final error = signal<String?>(null);
  static final showForecast = signal(false);

  // Timer for periodic updates
  static Timer? _refreshTimer;

  /// Initialize weather state and start periodic updates
  static void initialize() {
    // Load initial data
    loadWeatherData();

    // Set up periodic refresh every 3 hours
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(hours: 3), (timer) {
      loadWeatherData();
    });
  }

  /// Load weather data from the service
  static Future<void> loadWeatherData() async {
    try {
      isLoading.value = true;
      error.value = null;

      final current = await _service.getCurrentWeather();
      final forecastData = await _service.getForecast();

      currentWeather.value = current;
      forecast.value = forecastData;
      isLoading.value = false;
    } catch (e) {
      error.value = e.toString();
      isLoading.value = false;
    }
  }

  /// Toggle forecast visibility
  static void toggleForecast() {
    showForecast.value = !showForecast.value;
  }

  /// Clean up resources
  static void dispose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
