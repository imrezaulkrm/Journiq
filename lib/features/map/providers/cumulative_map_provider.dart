import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/utils/polyline_simplifier.dart';
import '../../history/providers/history_provider.dart';
import '../../journey/domain/models/journey_mode.dart';
import '../../journey/providers/tracking_provider.dart';

class CumulativeRoute {
  final String journeyId;
  final JourneyMode mode;
  final DateTime date;
  final double distanceMeters;
  final List<LatLng> simplifiedPoints;

  const CumulativeRoute({
    required this.journeyId,
    required this.mode,
    required this.date,
    required this.distanceMeters,
    required this.simplifiedPoints,
  });
}

class CumulativeMapData {
  final int totalRoutes;
  final double totalDistanceMeters;
  final List<CumulativeRoute> routes;

  const CumulativeMapData({
    required this.totalRoutes,
    required this.totalDistanceMeters,
    required this.routes,
  });

  factory CumulativeMapData.empty() => const CumulativeMapData(
    totalRoutes: 0,
    totalDistanceMeters: 0.0,
    routes: [],
  );
}

final cumulativeMapProvider = FutureProvider<CumulativeMapData>((ref) async {
  final journeys = await ref.watch(allJourneysProvider.future);
  if (journeys.isEmpty) return CumulativeMapData.empty();

  final repo = ref.watch(journeyRepositoryProvider);
  final routes = <CumulativeRoute>[];
  var totalDistance = 0.0;

  for (final j in journeys) {
    totalDistance += j.distanceMeters;
    final points = await repo.getPointsForJourney(j.id);
    final rawCoords = points.map((p) => p.toLatLng()).toList();

    // Ramer-Douglas-Peucker simplification for performance across hundreds of journeys
    final simplified = PolylineSimplifier.simplify(
      rawCoords,
      epsilonMeters: 10.0,
    );

    routes.add(
      CumulativeRoute(
        journeyId: j.id,
        mode: JourneyModeX.fromIndex(j.mode),
        date: j.startTime,
        distanceMeters: j.distanceMeters,
        simplifiedPoints: simplified,
      ),
    );
  }

  return CumulativeMapData(
    totalRoutes: routes.length,
    totalDistanceMeters: totalDistance,
    routes: routes,
  );
});
