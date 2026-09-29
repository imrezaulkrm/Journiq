class WeatherSnapshot {
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeedKmh;
  final int rainProbability;
  final List<int> hourlyRainProbabilities; // next 2 to 4 hours
  final DateTime observedAt;

  const WeatherSnapshot({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeedKmh,
    required this.rainProbability,
    required this.hourlyRainProbabilities,
    required this.observedAt,
  });

  /// Formatted outlook message based on upcoming 2 hours (Section 26)
  String get rainOutlookMessage {
    if (hourlyRainProbabilities.isEmpty) {
      if (rainProbability < 20) return 'Low chance of rain';
      if (rainProbability < 50) return 'Rain may be possible';
      return 'Rain likely';
    }

    final next2Hours = hourlyRainProbabilities.take(3).toList();
    final maxProb = next2Hours.fold(0, (max, p) => p > max ? p : max);

    if (maxProb < 20) {
      return 'Low chance of rain';
    } else if (maxProb < 50) {
      return 'Rain may be possible';
    } else if (maxProb < 75) {
      return 'Rain probability increasing';
    } else {
      return 'High chance of rain';
    }
  }

  /// String progression format (e.g. "15% → 20% → 35% → 45%")
  String get rainProgressionString {
    if (hourlyRainProbabilities.isEmpty) {
      return '$rainProbability%';
    }
    return hourlyRainProbabilities.take(4).map((p) => '$p%').join(' → ');
  }

  static String weatherCodeToCondition(int code) {
    switch (code) {
      case 0:
        return 'Clear Sky';
      case 1:
        return 'Mainly Clear';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Fair';
    }
  }
}
