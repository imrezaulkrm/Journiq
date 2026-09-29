import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/active_journeys_table.dart';

part 'active_journey_dao.g.dart';

@DriftAccessor(tables: [ActiveJourneys])
class ActiveJourneyDao extends DatabaseAccessor<AppDatabase> with _$ActiveJourneyDaoMixin {
  ActiveJourneyDao(super.db);

  Future<ActiveJourney?> getActiveJourney() =>
      select(activeJourneys).getSingleOrNull();

  Future<void> upsertActiveJourney(ActiveJourneysCompanion entry) =>
      into(activeJourneys).insert(entry, mode: InsertMode.insertOrReplace);

  Future<int> clearActiveJourney(String id) =>
      (delete(activeJourneys)..where((t) => t.id.equals(id))).go();

  Future<int> clearAllActive() => delete(activeJourneys).go();
}
