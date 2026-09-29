import 'package:drift/drift.dart';
import 'journeys_table.dart';

class JourneyPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get journeyId => text().references(Journeys, #id, onDelete: KeyAction.cascade)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get speedKmh => real().withDefault(const Constant(0.0))();
  RealColumn get accuracyMeters => real().withDefault(const Constant(0.0))();
  RealColumn get heading => real().nullable()();
}
