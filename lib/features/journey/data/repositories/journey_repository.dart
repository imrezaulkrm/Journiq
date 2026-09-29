import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../../database/app_database.dart';
import '../../domain/models/journey_mode.dart';
import '../../domain/models/tracking_point.dart';

abstract class JourneyRepository {
  Future<void> saveCompleteJourney({
    required String id,
    required JourneyMode mode,
    required DateTime startTime,
    required DateTime endTime,
    required int activeDurationSeconds,
    required double distanceMeters,
    required double averageSpeedKmh,
    required double maxSpeedKmh,
    required List<TrackingPoint> points,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    double? weatherTemperature,
    String? weatherCondition,
    int? weatherHumidity,
    double? weatherWindSpeed,
    int? weatherRainProbability,
    DateTime? weatherObservedAt,
    List<String> areasCovered = const [],
  });

  Future<void> insertPointsBatch(String journeyId, List<TrackingPoint> points);

  Future<List<Journey>> getAllJourneys();

  Stream<List<Journey>> watchAllJourneys();

  Future<Journey?> getJourney(String id);

  Future<List<TrackingPoint>> getPointsForJourney(String journeyId);

  Future<void> deleteJourney(String id);

  Future<List<Journey>> getJourneysForMonth(int year, int month);

  Stream<List<Journey>> watchJourneysForMonth(int year, int month);

  Future<ActiveJourney?> getActiveJourney();

  Future<void> saveActiveJourney(ActiveJourneysCompanion entry);

  Future<void> createJourneyDraft({
    required String id,
    required JourneyMode mode,
    required DateTime startTime,
  });

  Future<void> clearActiveJourney(String id);
}

class DriftJourneyRepository implements JourneyRepository {
  final AppDatabase _db;

  DriftJourneyRepository(this._db);

  @override
  Future<void> saveCompleteJourney({
    required String id,
    required JourneyMode mode,
    required DateTime startTime,
    required DateTime endTime,
    required int activeDurationSeconds,
    required double distanceMeters,
    required double averageSpeedKmh,
    required double maxSpeedKmh,
    required List<TrackingPoint> points,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    double? weatherTemperature,
    String? weatherCondition,
    int? weatherHumidity,
    double? weatherWindSpeed,
    int? weatherRainProbability,
    DateTime? weatherObservedAt,
    List<String> areasCovered = const [],
  }) async {
    // Transactional save for entire journey and points
    await _db.transaction(() async {
      await _db.journeysDao.insertJourney(
        JourneysCompanion(
          id: Value(id),
          mode: Value(mode.index),
          startTime: Value(startTime),
          endTime: Value(endTime),
          activeDurationSeconds: Value(activeDurationSeconds),
          distanceMeters: Value(distanceMeters),
          averageSpeedKmh: Value(averageSpeedKmh),
          maxSpeedKmh: Value(maxSpeedKmh),
          startLatitude: Value(startLatitude),
          startLongitude: Value(startLongitude),
          endLatitude: Value(endLatitude),
          endLongitude: Value(endLongitude),
          weatherTemperature: Value(weatherTemperature),
          weatherCondition: Value(weatherCondition),
          weatherHumidity: Value(weatherHumidity),
          weatherWindSpeed: Value(weatherWindSpeed),
          weatherRainProbability: Value(weatherRainProbability),
          weatherObservedAt: Value(weatherObservedAt),
          areasCovered: Value(jsonEncode(areasCovered)),
          createdAt: Value(DateTime.now()),
        ),
      );

      if (points.isNotEmpty) {
        final companions = points.map((p) => JourneyPointsCompanion.insert(
          journeyId: id,
          latitude: p.latitude,
          longitude: p.longitude,
          timestamp: p.timestamp,
          speedKmh: Value(p.speedKmh),
          accuracyMeters: Value(p.accuracyMeters),
          heading: Value(p.heading),
        )).toList();

        await _db.pointsDao.insertPointsBatch(companions);
      }

      // Clear active recovery state for this journey if exists
      await _db.activeJourneyDao.clearActiveJourney(id);
    });
  }

  @override
  Future<void> insertPointsBatch(String journeyId, List<TrackingPoint> points) async {
    if (points.isEmpty) return;
    final companions = points.map((p) => JourneyPointsCompanion.insert(
      journeyId: journeyId,
      latitude: p.latitude,
      longitude: p.longitude,
      timestamp: p.timestamp,
      speedKmh: Value(p.speedKmh),
      accuracyMeters: Value(p.accuracyMeters),
      heading: Value(p.heading),
    )).toList();

    await _db.pointsDao.insertPointsBatch(companions);
  }

  @override
  Future<List<Journey>> getAllJourneys() => _db.journeysDao.getAllJourneys();

  @override
  Stream<List<Journey>> watchAllJourneys() => _db.journeysDao.watchAllJourneys();

  @override
  Future<Journey?> getJourney(String id) => _db.journeysDao.getJourneyById(id);

  @override
  Future<List<TrackingPoint>> getPointsForJourney(String journeyId) async {
    final rows = await _db.pointsDao.getPointsForJourney(journeyId);
    return rows.map((r) => TrackingPoint(
      latitude: r.latitude,
      longitude: r.longitude,
      timestamp: r.timestamp,
      speedKmh: r.speedKmh,
      accuracyMeters: r.accuracyMeters,
      heading: r.heading,
    )).toList();
  }

  @override
  Future<void> deleteJourney(String id) async {
    // Foreign key CASCADE will delete points automatically
    await _db.journeysDao.deleteJourney(id);
  }

  @override
  Future<List<Journey>> getJourneysForMonth(int year, int month) =>
      _db.journeysDao.getJourneysForMonth(year, month);

  @override
  Stream<List<Journey>> watchJourneysForMonth(int year, int month) =>
      _db.journeysDao.watchJourneysForMonth(year, month);

  @override
  Future<ActiveJourney?> getActiveJourney() => _db.activeJourneyDao.getActiveJourney();

  @override
  Future<void> saveActiveJourney(ActiveJourneysCompanion entry) =>
      _db.activeJourneyDao.upsertActiveJourney(entry);

  @override
  Future<void> createJourneyDraft({
    required String id,
    required JourneyMode mode,
    required DateTime startTime,
  }) async {
    await _db.journeysDao.insertJourney(
      JourneysCompanion.insert(
        id: id,
        mode: mode.index,
        startTime: startTime,
        endTime: startTime,
        activeDurationSeconds: 0,
        distanceMeters: 0,
        averageSpeedKmh: 0,
        maxSpeedKmh: 0,
      ),
    );
  }

  @override
  Future<void> clearActiveJourney(String id) => _db.activeJourneyDao.clearActiveJourney(id);
}
