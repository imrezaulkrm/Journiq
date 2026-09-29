import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/journeys_table.dart';

part 'journeys_dao.g.dart';

@DriftAccessor(tables: [Journeys])
class JourneysDao extends DatabaseAccessor<AppDatabase> with _$JourneysDaoMixin {
  JourneysDao(super.db);

  Future<void> insertJourney(JourneysCompanion journey) =>
      into(journeys).insert(journey, mode: InsertMode.insertOrReplace);

  Future<int> updateJourney(String id, JourneysCompanion journey) =>
      (update(journeys)..where((t) => t.id.equals(id))).write(journey);

  Future<List<Journey>> getAllJourneys() =>
      (select(journeys)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).get();

  Stream<List<Journey>> watchAllJourneys() =>
      (select(journeys)..orderBy([(t) => OrderingTerm.desc(t.startTime)])).watch();

  Future<Journey?> getJourneyById(String id) =>
      (select(journeys)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> deleteJourney(String id) =>
      (delete(journeys)..where((t) => t.id.equals(id))).go();

  /// Strict Year + Month filtering required by specification Section 40
  Future<List<Journey>> getJourneysForMonth(int year, int month) {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = (month < 12)
        ? DateTime(year, month + 1, 1).subtract(const Duration(milliseconds: 1))
        : DateTime(year + 1, 1, 1).subtract(const Duration(milliseconds: 1));

    return (select(journeys)
          ..where((t) =>
              t.startTime.isBiggerOrEqualValue(startOfMonth) &
              t.startTime.isSmallerOrEqualValue(endOfMonth))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
  }

  Stream<List<Journey>> watchJourneysForMonth(int year, int month) {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = (month < 12)
        ? DateTime(year, month + 1, 1).subtract(const Duration(milliseconds: 1))
        : DateTime(year + 1, 1, 1).subtract(const Duration(milliseconds: 1));

    return (select(journeys)
          ..where((t) =>
              t.startTime.isBiggerOrEqualValue(startOfMonth) &
              t.startTime.isSmallerOrEqualValue(endOfMonth))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .watch();
  }
}
