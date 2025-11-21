import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../state/weather_state.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  List<Map<String, dynamic>> _getDailyForecast(Map<String, dynamic>? forecast) {
    if (forecast == null) return [];
    final list = forecast['list'] as List;
    final Map<String, Map<String, dynamic>> dailyMap = {};

    for (var item in list) {
      final dtTxt = item['dt_txt'] as String;
      final dateKey = dtTxt.split(' ')[0]; // YYYY-MM-DD
      final tempMin = (item['main']['temp_min'] as num).toDouble();
      final tempMax = (item['main']['temp_max'] as num).toDouble();

      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = {
          'date': dateKey,
          'min': tempMin,
          'max': tempMax,
          'item':
              item, // Keep one item for icon/desc (usually the first one found)
          'noon_diff': (DateTime.parse(dtTxt).hour - 12)
              .abs(), // To find closest to noon
        };
      } else {
        final day = dailyMap[dateKey]!;
        if (tempMin < day['min']) day['min'] = tempMin;
        if (tempMax > day['max']) day['max'] = tempMax;

        // Update representative item if this one is closer to noon
        final hourDiff = (DateTime.parse(dtTxt).hour - 12).abs();
        if (hourDiff < day['noon_diff']) {
          day['item'] = item;
          day['noon_diff'] = hourDiff;
        }
      }
    }

    // Convert map to list and take next 5 days
    return dailyMap.values.take(5).toList();
  }

  String _getWindDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      if (WeatherState.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      if (WeatherState.error.value != null) {
        return Text(
          'Error: ${WeatherState.error.value}',
          style: const TextStyle(color: Colors.red),
        );
      }

      if (WeatherState.currentWeather.value == null) {
        return const Text('Weather Unavailable');
      }

      return GestureDetector(
        onTap: WeatherState.toggleForecast,
        child: AnimatedCrossFade(
          firstChild: _buildCurrentWeather(context),
          secondChild: _buildForecast(context),
          crossFadeState: WeatherState.showForecast.value
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      );
    });
  }

  Widget _buildCurrentWeather(BuildContext context) {
    final currentWeather = WeatherState.currentWeather.value!;
    final temp = (currentWeather['main']['temp'] as num).round();
    var minTemp = (currentWeather['main']['temp_min'] as num).round();
    var maxTemp = (currentWeather['main']['temp_max'] as num).round();
    final humidity = currentWeather['main']['humidity'];
    final windSpeed = currentWeather['wind']['speed'];
    final description = currentWeather['weather'][0]['description'];
    final iconCode = currentWeather['weather'][0]['icon'];
    final location = currentWeather['name'];

    // Try to get better min/max from forecast
    final dailyForecast = _getDailyForecast(WeatherState.forecast.value);
    if (dailyForecast.isNotEmpty) {
      final today = dailyForecast.first;
      final todayDate = DateTime.parse(today['date']);
      final now = DateTime.now();

      // Check if the first forecast day is actually today
      if (todayDate.year == now.year &&
          todayDate.month == now.month &&
          todayDate.day == now.day) {
        minTemp = (today['min'] as num).round();
        maxTemp = (today['max'] as num).round();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: 'https://openweathermap.org/img/wn/$iconCode@2x.png',
              width: 50,
              height: 50,
              placeholder: (context, url) =>
                  const Icon(Icons.cloud, color: Colors.white),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(
              '$temp°',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          location,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white70),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Text(
          description.toString().toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white60),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.thermostat, size: 16, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              '$minTemp°/$maxTemp°',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.water_drop, size: 16, color: Colors.white70),
            const SizedBox(width: 4),
            Text('$humidity%', style: const TextStyle(color: Colors.white70)),
            const SizedBox(width: 16),
            const Icon(Icons.air, size: 16, color: Colors.white70),
            const SizedBox(width: 4),
            Text(
              '${windSpeed}m/s',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForecast(BuildContext context) {
    final dailyForecast = _getDailyForecast(WeatherState.forecast.value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '5-Day Forecast',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          ...dailyForecast.map((dayData) {
            final item = dayData['item'];
            final date = DateTime.parse(dayData['date']);
            final minTemp = (dayData['min'] as num).round();
            final maxTemp = (dayData['max'] as num).round();
            final feelsLike = (item['main']['feels_like'] as num).round();
            final humidity = item['main']['humidity'];
            final pressure = item['main']['pressure'];
            final seaLevel = item['main']['sea_level'] ?? pressure;
            final grndLevel = item['main']['grnd_level'] ?? pressure;
            final pop = (item['pop'] as num).toDouble();
            final windSpeed = item['wind']['speed'];
            final windDeg = item['wind']['deg'] ?? 0;
            final windGust = item['wind']['gust'];
            final clouds = item['clouds']['all'];
            final visibility = item['visibility'] ?? 10000;
            final rain3h = item['rain']?['3h'];
            final snow3h = item['snow']?['3h'];
            final iconCode = item['weather'][0]['icon'];
            final description = item['weather'][0]['description'];
            final dayName = DateFormat('EEEE').format(date);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main row: Day, Icon, Temp
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          dayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CachedNetworkImage(
                        imageUrl:
                            'https://openweathermap.org/img/wn/$iconCode.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$minTemp°/$maxTemp°',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    description.toUpperCase(),
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  // Details row 1: Feels like, Humidity, Pressure
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.thermostat,
                            size: 12,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Feels $feelsLike°',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            size: 12,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$humidity%',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.compress,
                            size: 12,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${pressure}hPa',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water,
                            size: 12,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Sea ${seaLevel}hPa',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.terrain,
                            size: 12,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Gnd ${grndLevel}hPa',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Details row 2: Wind, Clouds, Visibility, Rain
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.air,
                            size: 12,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${windSpeed}m/s ${_getWindDirection(windDeg)}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      if (windGust != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.wind_power,
                              size: 12,
                              color: Colors.white60,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Gust ${windGust}m/s',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud,
                            size: 12,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$clouds%',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            size: 12,
                            color: Colors.white60,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${(visibility / 1000).toStringAsFixed(1)}km',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      if (pop > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.umbrella,
                              size: 12,
                              color: Colors.lightBlueAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(pop * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      if (rain3h != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.water_drop,
                              size: 12,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${rain3h}mm',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      if (snow3h != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.ac_unit,
                              size: 12,
                              color: Colors.lightBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${snow3h}mm',
                              style: const TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
