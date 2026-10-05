import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../history/providers/history_provider.dart';
import '../../journey/domain/models/journey_mode.dart';

class MobilityStatistics {
  final int totalJourneys;
  final double totalDistanceMeters;
  final int totalActiveSeconds;
  final double averageDistanceMeters;
  final double averageSpeedKmh;
  final double maxSpeedKmh;
  final double longestDistanceMeters;
  final int monthJourneys;
  final double monthDistanceMeters;
  final Map<JourneyMode, ({int count, double distanceMeters})> modeStats;

  const MobilityStatistics({
    required this.totalJourneys,
    required this.totalDistanceMeters,
    required this.totalActiveSeconds,
    required this.averageDistanceMeters,
    required this.averageSpeedKmh,
    required this.maxSpeedKmh,
    required this.longestDistanceMeters,
    required this.monthJourneys,
    required this.monthDistanceMeters,
    required this.modeStats,
  });

  factory MobilityStatistics.empty() {
    final emptyModeMap = <JourneyMode, ({int count, double distanceMeters})>{};
    for (final mode in JourneyMode.values) {
      emptyModeMap[mode] = (count: 0, distanceMeters: 0.0);
    }

    return MobilityStatistics(
      totalJourneys: 0,
      totalDistanceMeters: 0.0,
      totalActiveSeconds: 0,
      averageDistanceMeters: 0.0,
      averageSpeedKmh: 0.0,
      maxSpeedKmh: 0.0,
      longestDistanceMeters: 0.0,
      monthJourneys: 0,
      monthDistanceMeters: 0.0,
      modeStats: emptyModeMap,
    );
  }
}

final statisticsProvider = Provider<AsyncValue<MobilityStatistics>>((ref) {
  final journeysAsync = ref.watch(allJourneysProvider);

  return journeysAsync.whenData((journeys) {
    if (journeys.isEmpty) return MobilityStatistics.empty();

    final now = DateTime.now();
    var totalDistance = 0.0;
    var totalSeconds = 0;
    var maxSpeed = 0.0;
    var longestDistance = 0.0;
    var monthJourneysCount = 0;
    var monthDistance = 0.0;

    final modeMap = <JourneyMode, ({int count, double distanceMeters})>{};
    for (final mode in JourneyMode.values) {
      modeMap[mode] = (count: 0, distanceMeters: 0.0);
    }

    for (final j in journeys) {
      totalDistance += j.distanceMeters;
      totalSeconds += j.activeDurationSeconds;

      if (j.maxSpeedKmh > maxSpeed) {
        maxSpeed = j.maxSpeedKmh;
      }
      if (j.distanceMeters > longestDistance) {
        longestDistance = j.distanceMeters;
      }

      // CRITICAL: Strict Year + Month filtering (Section 40)
      if (j.startTime.year == now.year && j.startTime.month == now.month) {
        monthJourneysCount++;
        monthDistance += j.distanceMeters;
      }

      final mode = JourneyModeX.fromIndex(j.mode);
      final currentModeStats = modeMap[mode] ?? (count: 0, distanceMeters: 0.0);
      modeMap[mode] = (
        count: currentModeStats.count + 1,
        distanceMeters: currentModeStats.distanceMeters + j.distanceMeters,
      );
    }

    final avgDistance = totalDistance / journeys.length;
    final avgSpeed = totalSeconds > 0
        ? (totalDistance / totalSeconds) * 3.6
        : 0.0;

    return MobilityStatistics(
      totalJourneys: journeys.length,
      totalDistanceMeters: totalDistance,
      totalActiveSeconds: totalSeconds,
      averageDistanceMeters: avgDistance,
      averageSpeedKmh: avgSpeed,
      maxSpeedKmh: maxSpeed,
      longestDistanceMeters: longestDistance,
      monthJourneys: monthJourneysCount,
      monthDistanceMeters: monthDistance,
      modeStats: modeMap,
    );
  });
});
