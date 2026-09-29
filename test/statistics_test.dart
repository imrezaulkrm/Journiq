import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journiq/database/app_database.dart';
import 'package:journiq/features/history/providers/history_provider.dart';
import 'package:journiq/features/journey/domain/models/journey_mode.dart';
import 'package:journiq/features/statistics/providers/statistics_provider.dart';

Journey makeTestJourney({
  required String id,
  required JourneyMode mode,
  required DateTime startTime,
  required double distanceMeters,
  required int durationSeconds,
  double maxSpeedKmh = 10.0,
}) {
  return Journey(
    id: id,
    mode: mode.index,
    startTime: startTime,
    endTime: startTime.add(Duration(seconds: durationSeconds)),
    activeDurationSeconds: durationSeconds,
    distanceMeters: distanceMeters,
    averageSpeedKmh: durationSeconds > 0 ? (distanceMeters / durationSeconds) * 3.6 : 0.0,
    maxSpeedKmh: maxSpeedKmh,
    areasCovered: '[]',
    createdAt: startTime,
  );
}

void main() {
  group('MobilityStatistics Calculation', () {
    test('strictly computes current month using CURRENT YEAR + CURRENT MONTH', () async {
      final now = DateTime.now();
      final thisYearThisMonth = DateTime(now.year, now.month, 15);
      final lastYearSameMonth = DateTime(now.year - 1, now.month, 15);
      final thisYearOtherMonth = DateTime(now.year, now.month == 1 ? 2 : now.month - 1, 15);

      final journeys = [
        makeTestJourney(
          id: 'j1',
          mode: JourneyMode.walking,
          startTime: thisYearThisMonth,
          distanceMeters: 1000.0,
          durationSeconds: 600,
        ),
        makeTestJourney(
          id: 'j2',
          mode: JourneyMode.walking,
          startTime: thisYearThisMonth,
          distanceMeters: 2000.0,
          durationSeconds: 1200,
        ),
        // Last year same month: MUST NOT be counted in This Month
        makeTestJourney(
          id: 'j3_old_year',
          mode: JourneyMode.bicycle,
          startTime: lastYearSameMonth,
          distanceMeters: 5000.0,
          durationSeconds: 1500,
        ),
        // This year but different month: MUST NOT be counted in This Month
        makeTestJourney(
          id: 'j4_other_month',
          mode: JourneyMode.car,
          startTime: thisYearOtherMonth,
          distanceMeters: 10000.0,
          durationSeconds: 1800,
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          allJourneysProvider.overrideWith((ref) => Stream.value(journeys)),
        ],
      );
      addTearDown(container.dispose);

      await container.read(allJourneysProvider.future);
      final statsAsync = container.read(statisticsProvider);
      expect(statsAsync, isA<AsyncData<MobilityStatistics>>());

      final stats = statsAsync.value!;

      // Total includes all 4 journeys
      expect(stats.totalJourneys, 4);
      expect(stats.totalDistanceMeters, 18000.0);

      // Strict Current Month: only j1 and j2 (1000m + 2000m = 3000m)
      expect(stats.monthJourneys, 2);
      expect(stats.monthDistanceMeters, 3000.0);

      // Mode Stats aggregation
      expect(stats.modeStats[JourneyMode.walking]?.count, 2);
      expect(stats.modeStats[JourneyMode.walking]?.distanceMeters, 3000.0);
      expect(stats.modeStats[JourneyMode.bicycle]?.count, 1);
      expect(stats.modeStats[JourneyMode.car]?.count, 1);
      expect(stats.modeStats[JourneyMode.train]?.count, 0);
    });
  });
}
