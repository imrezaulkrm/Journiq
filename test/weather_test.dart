import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:journiq/features/weather/data/weather_service.dart';
import 'package:journiq/features/weather/domain/models/weather_snapshot.dart';

void main() {
  group('WeatherSnapshot and WeatherService', () {
    test('computes correct rain outlook message', () {
      final lowRain = WeatherSnapshot(
        temperature: 25.0,
        condition: 'Clear Sky',
        humidity: 60,
        windSpeedKmh: 12.0,
        rainProbability: 10,
        hourlyRainProbabilities: [5, 10, 15],
        observedAt: DateTime.now(),
      );
      expect(lowRain.rainOutlookMessage, 'Low chance of rain');

      final increasingRain = WeatherSnapshot(
        temperature: 24.0,
        condition: 'Overcast',
        humidity: 80,
        windSpeedKmh: 18.0,
        rainProbability: 35,
        hourlyRainProbabilities: [30, 45, 65],
        observedAt: DateTime.now(),
      );
      expect(increasingRain.rainOutlookMessage, 'Rain probability increasing');

      final highRain = WeatherSnapshot(
        temperature: 22.0,
        condition: 'Moderate Rain',
        humidity: 90,
        windSpeedKmh: 25.0,
        rainProbability: 80,
        hourlyRainProbabilities: [80, 85, 90],
        observedAt: DateTime.now(),
      );
      expect(highRain.rainOutlookMessage, 'High chance of rain');
    });

    test('maps WMO weather codes to human readable conditions', () {
      expect(WeatherSnapshot.weatherCodeToCondition(0), 'Clear Sky');
      expect(WeatherSnapshot.weatherCodeToCondition(3), 'Overcast');
      expect(WeatherSnapshot.weatherCodeToCondition(61), 'Rain');
      expect(WeatherSnapshot.weatherCodeToCondition(95), 'Thunderstorm');
    });

    test('OpenMeteoWeatherService parses response successfully', () async {
      final mockResponse = jsonEncode({
        'current': {
          'temperature_2m': 28.4,
          'relative_humidity_2m': 72,
          'weather_code': 2,
          'wind_speed_10m': 14.5,
        },
        'hourly': {
          'precipitation_probability': [15, 20, 30, 45, 60],
        },
      });

      final mockClient = MockClient((request) async {
        return http.Response(mockResponse, 200);
      });

      final service = OpenMeteoWeatherService(mockClient);
      final snapshot = await service.getWeather(23.8103, 90.4125);

      expect(snapshot, isNotNull);
      expect(snapshot!.temperature, 28.4);
      expect(snapshot.condition, 'Partly Cloudy');
      expect(snapshot.humidity, 72);
      expect(snapshot.windSpeedKmh, 14.5);
      expect(snapshot.rainProbability, 15);
      expect(snapshot.hourlyRainProbabilities, [15, 20, 30, 45, 60]);
    });

    test(
      'OpenMeteoWeatherService handles network failure gracefully without throwing',
      () async {
        final failingClient = MockClient((request) async {
          throw Exception('Network unreachable');
        });

        final service = OpenMeteoWeatherService(failingClient);
        final snapshot = await service.getWeather(23.8103, 90.4125);

        // Must return null or cache safely, never crash tracking
        expect(snapshot, isNull);
      },
    );
  });
}
