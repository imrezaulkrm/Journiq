import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journiq/database/app_database.dart';
import 'package:journiq/features/journey/data/repositories/journey_repository.dart';
import 'package:journiq/features/journey/domain/models/journey_mode.dart';
import 'package:journiq/features/journey/domain/models/tracking_point.dart';

import 'dart:ffi';
import 'package:sqlite3/open.dart';

void main() {
  late AppDatabase db;
  late DriftJourneyRepository repository;

  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () => DynamicLibrary.open('/usr/lib/x86_64-linux-gnu/libsqlite3.so.0'));
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftJourneyRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift Database & Repository', () {
    test('saves complete journey and points transactionally', () async {
      final now = DateTime(2026, 9, 29, 10, 0, 0);
      final points = [
        TrackingPoint(
          latitude: 23.8103,
          longitude: 90.4125,
          timestamp: now,
          speedKmh: 4.5,
          accuracyMeters: 6.0,
        ),
        TrackingPoint(
          latitude: 23.8115,
          longitude: 90.4135,
          timestamp: now.add(const Duration(seconds: 60)),
          speedKmh: 5.2,
          accuracyMeters: 5.5,
        ),
      ];

      await repository.saveCompleteJourney(
        id: 'test_journey_1',
        mode: JourneyMode.walking,
        startTime: now,
        endTime: now.add(const Duration(minutes: 10)),
        activeDurationSeconds: 600,
        distanceMeters: 850.0,
        averageSpeedKmh: 5.1,
        maxSpeedKmh: 6.2,
        points: points,
        startLatitude: 23.8103,
        startLongitude: 90.4125,
        endLatitude: 23.8115,
        endLongitude: 90.4135,
        weatherTemperature: 28.5,
        weatherCondition: 'Clear sky',
        areasCovered: ['Gulshan', 'Banani'],
      );

      final retrieved = await repository.getJourney('test_journey_1');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, 'test_journey_1');
      expect(retrieved.distanceMeters, 850.0);
      expect(retrieved.weatherCondition, 'Clear sky');

      final savedPoints = await repository.getPointsForJourney('test_journey_1');
      expect(savedPoints.length, 2);
      expect(savedPoints.first.latitude, 23.8103);
      expect(savedPoints.last.latitude, 23.8115);
    });

    test('deleting journey cascade deletes points and active entries', () async {
      final now = DateTime(2026, 9, 29, 10, 0, 0);
      final points = <TrackingPoint>[
        TrackingPoint(
          latitude: 23.8103,
          longitude: 90.4125,
          timestamp: now,
          speedKmh: 0.0,
          accuracyMeters: 5.0,
        ),
      ];

      await repository.saveCompleteJourney(
        id: 'cascade_test_journey',
        mode: JourneyMode.bicycle,
        startTime: now,
        endTime: now.add(const Duration(minutes: 5)),
        activeDurationSeconds: 300,
        distanceMeters: 1200.0,
        averageSpeedKmh: 14.4,
        maxSpeedKmh: 18.0,
        points: points,
      );

      expect((await repository.getPointsForJourney('cascade_test_journey')).length, 1);

      // Delete the journey
      await repository.deleteJourney('cascade_test_journey');

      // Verify journey is removed
      final deleted = await repository.getJourney('cascade_test_journey');
      expect(deleted, isNull);

      // Verify points were cascade deleted
      final pointsAfterDelete = await repository.getPointsForJourney('cascade_test_journey');
      expect(pointsAfterDelete, isEmpty);
    });

    test('active journey recovery persistence and discard', () async {
      final now = DateTime(2026, 9, 29, 10, 0, 0);

      await repository.saveActiveJourney(
        ActiveJourneysCompanion(
          id: const drift.Value('active_recovery_1'),
          mode: const drift.Value(0),
          startTime: drift.Value(now),
          activeDurationSeconds: const drift.Value(120),
          distanceMeters: const drift.Value(450.0),
          maxSpeedKmh: const drift.Value(5.5),
          isPaused: const drift.Value(false),
          lastUpdated: drift.Value(now),
        ),
      );

      final active = await repository.getActiveJourney();
      expect(active, isNotNull);
      expect(active!.id, 'active_recovery_1');
      expect(active.distanceMeters, 450.0);

      await repository.clearActiveJourney('active_recovery_1');
      final cleared = await repository.getActiveJourney();
      expect(cleared, isNull);
    });
  });
}
