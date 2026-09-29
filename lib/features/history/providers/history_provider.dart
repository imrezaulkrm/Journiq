import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/app_database.dart';
import '../../journey/domain/models/tracking_point.dart';
import '../../journey/providers/tracking_provider.dart';

final allJourneysProvider = StreamProvider<List<Journey>>((ref) {
  final repo = ref.watch(journeyRepositoryProvider);
  return repo.watchAllJourneys();
});

final journeyDetailProvider = FutureProvider.family<({Journey? journey, List<TrackingPoint> points}), String>((ref, id) async {
  final repo = ref.watch(journeyRepositoryProvider);
  final journey = await repo.getJourney(id);
  final points = await repo.getPointsForJourney(id);
  return (journey: journey, points: points);
});
