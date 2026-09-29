import 'package:drift/drift.dart';

class Journeys extends Table {
  TextColumn get id => text()();
  IntColumn get mode => integer()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get activeDurationSeconds => integer()();
  RealColumn get distanceMeters => real()();
  RealColumn get averageSpeedKmh => real()();
  RealColumn get maxSpeedKmh => real()();

  RealColumn get startLatitude => real().nullable()();
  RealColumn get startLongitude => real().nullable()();
  RealColumn get endLatitude => real().nullable()();
  RealColumn get endLongitude => real().nullable()();

  RealColumn get weatherTemperature => real().nullable()();
  TextColumn get weatherCondition => text().nullable()();
  IntColumn get weatherHumidity => integer().nullable()();
  RealColumn get weatherWindSpeed => real().nullable()();
  IntColumn get weatherRainProbability => integer().nullable()();
  DateTimeColumn get weatherObservedAt => dateTime().nullable()();

  TextColumn get areasCovered => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
