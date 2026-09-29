// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_dao.dart';

// ignore_for_file: type=lint
mixin _$PointsDaoMixin on DatabaseAccessor<AppDatabase> {
  $JourneysTable get journeys => attachedDatabase.journeys;
  $JourneyPointsTable get journeyPoints => attachedDatabase.journeyPoints;
  PointsDaoManager get managers => PointsDaoManager(this);
}

class PointsDaoManager {
  final _$PointsDaoMixin _db;
  PointsDaoManager(this._db);
  $$JourneysTableTableManager get journeys =>
      $$JourneysTableTableManager(_db.attachedDatabase, _db.journeys);
  $$JourneyPointsTableTableManager get journeyPoints =>
      $$JourneyPointsTableTableManager(_db.attachedDatabase, _db.journeyPoints);
}
