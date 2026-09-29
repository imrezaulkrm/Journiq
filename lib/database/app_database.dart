import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/active_journey_dao.dart';
import 'daos/journeys_dao.dart';
import 'daos/points_dao.dart';
import 'tables/active_journeys_table.dart';
import 'tables/journey_points_table.dart';
import 'tables/journeys_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Journeys, JourneyPoints, ActiveJourneys],
  daos: [JourneysDao, PointsDao, ActiveJourneyDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Enforce SQLite Foreign Keys for cascade delete
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'journiq_app_database');
  }
}
