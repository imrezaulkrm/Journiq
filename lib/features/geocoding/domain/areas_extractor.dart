import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../journey/domain/models/tracking_point.dart';
import '../data/geocoding_service.dart';

class AreasCoveredExtractor {
  final IGeocodingService _geocodingService;

  AreasCoveredExtractor(this._geocodingService);

  /// Samples points from the route at ~1.5 km intervals, reverse-geocodes them,
  /// and returns a deduplicated list of areas visited.
  Future<List<String>> extractAreas(List<TrackingPoint> points) async {
    if (points.isEmpty) return const [];

    final sampledPoints = <TrackingPoint>[points.first];
    var lastSampled = points.first;

    for (var i = 1; i < points.length; i++) {
      final p = points[i];
      final distance = DistanceCalculator.haversineDistanceMeters(
        lastSampled.latitude,
        lastSampled.longitude,
        p.latitude,
        p.longitude,
      );

      if (distance >= AppConstants.geocodingSamplingDistanceMeters) {
        sampledPoints.add(p);
        lastSampled = p;
      }
    }

    // Always include end point if distant enough from last sampled
    if (points.length > 1) {
      final lastPoint = points.last;
      final distanceToEnd = DistanceCalculator.haversineDistanceMeters(
        lastSampled.latitude,
        lastSampled.longitude,
        lastPoint.latitude,
        lastPoint.longitude,
      );
      if (distanceToEnd > 400) {
        sampledPoints.add(lastPoint);
      }
    }

    final uniqueAreas = <String>{};

    for (final pt in sampledPoints) {
      final area = await _geocodingService.reverseGeocode(
        pt.latitude,
        pt.longitude,
      );
      if (area != null && area.isNotEmpty) {
        uniqueAreas.add(area);
      }
    }

    return uniqueAreas.toList(growable: false);
  }
}
