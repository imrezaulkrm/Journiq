import 'package:drift/drift.dart';

class ActiveJourneys extends Table {
  TextColumn get id => text()();
  IntColumn get mode => integer()();
  DateTimeColumn get startTime => dateTime()();
  IntColumn get activeDurationSeconds => integer()();
  RealColumn get distanceMeters => real()();
  RealColumn get maxSpeedKmh => real()();
  BoolColumn get isPaused => boolean().withDefault(const Constant(false))();
  DateTimeColumn get pausedAt => dateTime().nullable()();
  DateTimeColumn get lastUpdated => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
