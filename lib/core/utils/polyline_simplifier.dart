import 'dart:math' as math;

import 'package:latlong2/latlong.dart' hide DistanceCalculator;
import 'distance_calculator.dart';

class PolylineSimplifier {
  /// Simplifies a polyline using the Ramer-Douglas-Peucker algorithm.
  /// [epsilonMeters] is the maximum perpendicular distance in meters a point can deviate.
  static List<LatLng> simplify(List<LatLng> points, {double epsilonMeters = 8.0}) {
    if (points.length <= 2) return points;

    return _rdp(points, 0, points.length - 1, epsilonMeters);
  }

  static List<LatLng> _rdp(List<LatLng> points, int startIndex, int endIndex, double epsilon) {
    var maxDistance = 0.0;
    var index = startIndex;

    final startPoint = points[startIndex];
    final endPoint = points[endIndex];

    for (var i = startIndex + 1; i < endIndex; i++) {
      final distance = _perpendicularDistanceMeters(points[i], startPoint, endPoint);
      if (distance > maxDistance) {
        maxDistance = distance;
        index = i;
      }
    }

    if (maxDistance > epsilon) {
      final left = _rdp(points, startIndex, index, epsilon);
      final right = _rdp(points, index, endIndex, epsilon);

      // Concatenate results avoiding duplicate midpoint
      return [...left.sublist(0, left.length - 1), ...right];
    } else {
      return [points[startIndex], points[endIndex]];
    }
  }

  /// Calculates perpendicular distance of point P from the line connecting A and B in meters.
  static double _perpendicularDistanceMeters(LatLng p, LatLng a, LatLng b) {
    final dAB = DistanceCalculator.haversineDistanceMeters(a.latitude, a.longitude, b.latitude, b.longitude);
    if (dAB == 0) {
      return DistanceCalculator.haversineDistanceMeters(p.latitude, p.longitude, a.latitude, a.longitude);
    }

    final dAP = DistanceCalculator.haversineDistanceMeters(a.latitude, a.longitude, p.latitude, p.longitude);
    final dBP = DistanceCalculator.haversineDistanceMeters(b.latitude, b.longitude, p.latitude, p.longitude);

    // Heron's formula for triangle area
    final s = (dAB + dAP + dBP) / 2.0;
    final areaSq = s * (s - dAB) * (s - dAP) * (s - dBP);
    if (areaSq <= 0) return 0.0;

    // Height = 2 * Area / Base
    // Using simple vector cross-product approximation on planar projection:
    final dx = b.longitude - a.longitude;
    final dy = b.latitude - a.latitude;
    final numerator = ((dy * p.longitude) - (dx * p.latitude) + (b.latitude * a.longitude) - (b.longitude * a.latitude)).abs();
    final denominator = (dy * dy + dx * dx);
    if (denominator == 0) return dAP;

    // Convert degrees ratio to meters approximation:
    final ratio = numerator / (denominator > 0 ? (denominator > 0 ? (denominator) : 1) : 1);
    final midLat = (a.latitude + b.latitude) / 2.0;
    final metersPerDegLat = 111132.0;
    final metersPerDegLng = 111320.0 * math.cos(midLat * math.pi / 180).abs();
    final approxMeters = ratio * ((metersPerDegLat + metersPerDegLng) / 2.0);

    return approxMeters.clamp(0.0, 50000.0);
  }
}
