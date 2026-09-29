// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_journey_dao.dart';

// ignore_for_file: type=lint
mixin _$ActiveJourneyDaoMixin on DatabaseAccessor<AppDatabase> {
  $ActiveJourneysTable get activeJourneys => attachedDatabase.activeJourneys;
  ActiveJourneyDaoManager get managers => ActiveJourneyDaoManager(this);
}

class ActiveJourneyDaoManager {
  final _$ActiveJourneyDaoMixin _db;
  ActiveJourneyDaoManager(this._db);
  $$ActiveJourneysTableTableManager get activeJourneys =>
      $$ActiveJourneysTableTableManager(
        _db.attachedDatabase,
        _db.activeJourneys,
      );
}
