import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/journey_points_table.dart';

part 'points_dao.g.dart';

@DriftAccessor(tables: [JourneyPoints])
class PointsDao extends DatabaseAccessor<AppDatabase> with _$PointsDaoMixin {
  PointsDao(super.db);

  Future<void> insertPointsBatch(
    List<JourneyPointsCompanion> pointsList,
  ) async {
    await batch((batch) {
      batch.insertAll(journeyPoints, pointsList);
    });
  }

  Future<List<JourneyPoint>> getPointsForJourney(String journeyId) =>
      (select(journeyPoints)
            ..where((t) => t.journeyId.equals(journeyId))
            ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
          .get();

  Stream<List<JourneyPoint>> watchPointsForJourney(String journeyId) =>
      (select(journeyPoints)
            ..where((t) => t.journeyId.equals(journeyId))
            ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
          .watch();

  Future<int> deletePointsForJourney(String journeyId) =>
      (delete(journeyPoints)..where((t) => t.journeyId.equals(journeyId))).go();
}
