import 'dart:math' as math;

class DistanceCalculator {
  static const double _earthRadiusMeters = 6371000.0;

  /// Calculates geodesic distance between two coordinates in meters using Haversine formula
  static double haversineDistanceMeters(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    if (startLat == endLat && startLng == endLng) return 0.0;

    final dLat = _degToRad(endLat - startLat);
    final dLon = _degToRad(endLng - startLng);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(startLat)) *
            math.cos(_degToRad(endLat)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return _earthRadiusMeters * c;
  }

  static double _degToRad(double degrees) => degrees * (math.pi / 180.0);
}
