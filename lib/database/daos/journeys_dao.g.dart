// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journeys_dao.dart';

// ignore_for_file: type=lint
mixin _$JourneysDaoMixin on DatabaseAccessor<AppDatabase> {
  $JourneysTable get journeys => attachedDatabase.journeys;
  JourneysDaoManager get managers => JourneysDaoManager(this);
}

class JourneysDaoManager {
  final _$JourneysDaoMixin _db;
  JourneysDaoManager(this._db);
  $$JourneysTableTableManager get journeys =>
      $$JourneysTableTableManager(_db.attachedDatabase, _db.journeys);
}
