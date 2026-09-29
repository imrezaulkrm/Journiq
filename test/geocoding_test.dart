import 'package:flutter_test/flutter_test.dart';
import 'package:journiq/features/geocoding/data/geocoding_service.dart';
import 'package:journiq/features/geocoding/domain/areas_extractor.dart';
import 'package:journiq/features/journey/domain/models/tracking_point.dart';

class MockGeocodingService implements IGeocodingService {
  final Map<String, String> responses = {
    '23.81,90.41': 'Gulshan',
    '23.83,90.41': 'Banani',
    '23.85,90.41': 'Uttara',
  };

  int callCount = 0;

  @override
  Future<String?> reverseGeocode(double latitude, double longitude) async {
    callCount++;
    final key = '${latitude.toStringAsFixed(2)},${longitude.toStringAsFixed(2)}';
    return responses[key];
  }
}

void main() {
  group('AreasCoveredExtractor', () {
    test('samples points at ~1.5 km intervals and deduplicates visited areas', () async {
      final mock = MockGeocodingService();
      final extractor = AreasCoveredExtractor(mock);

      final now = DateTime(2026, 9, 29, 10, 0, 0);

      // Create route of 10 points spanning from Gulshan to Uttara (~5 km)
      final points = <TrackingPoint>[
        // Point 0: Start at Gulshan
        TrackingPoint(latitude: 23.8100, longitude: 90.4125, timestamp: now, speedKmh: 20, accuracyMeters: 5),
        // Point 1: 500m away (Gulshan) - should be skipped by 1.5km threshold
        TrackingPoint(latitude: 23.8145, longitude: 90.4125, timestamp: now.add(const Duration(seconds: 60)), speedKmh: 20, accuracyMeters: 5),
        // Point 2: ~2.2 km from start (Banani) - should be sampled!
        TrackingPoint(latitude: 23.8300, longitude: 90.4125, timestamp: now.add(const Duration(seconds: 180)), speedKmh: 20, accuracyMeters: 5),
        // Point 3: ~2.2 km from Point 2 (Uttara) - should be sampled!
        TrackingPoint(latitude: 23.8500, longitude: 90.4125, timestamp: now.add(const Duration(seconds: 300)), speedKmh: 20, accuracyMeters: 5),
        // Point 4: Close to Point 3 (Uttara) - duplicate area
        TrackingPoint(latitude: 23.8520, longitude: 90.4125, timestamp: now.add(const Duration(seconds: 320)), speedKmh: 20, accuracyMeters: 5),
      ];

      final areas = await extractor.extractAreas(points);

      // Only unique areas returned
      expect(areas, containsAll(['Gulshan', 'Banani', 'Uttara']));
      expect(areas.length, 3);
      // Sample count should be far fewer than total points (5 points -> 3 or 4 reverse geocodes)
      expect(mock.callCount, lessThanOrEqualTo(4));
    });

    test('returns empty list for empty point collection', () async {
      final mock = MockGeocodingService();
      final extractor = AreasCoveredExtractor(mock);

      final areas = await extractor.extractAreas([]);
      expect(areas, isEmpty);
      expect(mock.callCount, 0);
    });
  });
}
