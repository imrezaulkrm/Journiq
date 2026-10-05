import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/models/weather_snapshot.dart';

abstract class IWeatherService {
  Future<WeatherSnapshot?> getWeather(double latitude, double longitude);
}

class OpenMeteoWeatherService implements IWeatherService {
  final http.Client _client;

  // Cache last known weather to avoid duplicate network calls
  WeatherSnapshot? _cachedSnapshot;
  double? _cachedLat;
  double? _cachedLng;
  DateTime? _cachedTime;

  OpenMeteoWeatherService([http.Client? client])
    : _client = client ?? http.Client();

  @override
  Future<WeatherSnapshot?> getWeather(double latitude, double longitude) async {
    // Return cache if request is within 15 minutes and close coordinates (< 2 km)
    if (_cachedSnapshot != null &&
        _cachedLat != null &&
        _cachedLng != null &&
        _cachedTime != null) {
      final age = DateTime.now().difference(_cachedTime!).inMinutes;
      if (age < 15 &&
          (latitude - _cachedLat!).abs() < 0.02 &&
          (longitude - _cachedLng!).abs() < 0.02) {
        return _cachedSnapshot;
      }
    }

    try {
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?'
        'latitude=$latitude&longitude=$longitude&'
        'current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m&'
        'hourly=precipitation_probability,weather_code&forecast_hours=6',
      );

      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return _cachedSnapshot;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final current = data['current'] as Map<String, dynamic>;
      final hourly = data['hourly'] as Map<String, dynamic>?;

      final temp = (current['temperature_2m'] as num).toDouble();
      final humidity = (current['relative_humidity_2m'] as num).toInt();
      final weatherCode = (current['weather_code'] as num).toInt();
      final windSpeed = (current['wind_speed_10m'] as num).toDouble();

      List<int> rainProbabilities = [];
      if (hourly != null && hourly['precipitation_probability'] is List) {
        final rawList = hourly['precipitation_probability'] as List;
        rainProbabilities = rawList
            .take(6)
            .map((v) => (v as num).toInt())
            .toList(growable: false);
      }

      final currentRainProb = rainProbabilities.isNotEmpty
          ? rainProbabilities.first
          : 0;

      final snapshot = WeatherSnapshot(
        temperature: temp,
        condition: WeatherSnapshot.weatherCodeToCondition(weatherCode),
        humidity: humidity,
        windSpeedKmh: windSpeed,
        rainProbability: currentRainProb,
        hourlyRainProbabilities: rainProbabilities,
        observedAt: DateTime.now(),
      );

      _cachedSnapshot = snapshot;
      _cachedLat = latitude;
      _cachedLng = longitude;
      _cachedTime = DateTime.now();

      return snapshot;
    } catch (_) {
      // Failures should never interrupt tracking or throw
      return _cachedSnapshot;
    }
  }
}
