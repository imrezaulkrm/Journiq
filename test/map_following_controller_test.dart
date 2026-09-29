import 'dart:math' as math;
// import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:journiq/features/map/controllers/map_following_controller.dart';

class MockMapController implements MapController {
  LatLng center = const LatLng(23.8103, 90.4125);
  double zoom = 16.0;
  int moveCount = 0;

  @override
  MapCamera get camera => MapCamera(
        crs: const Epsg3857(),
        minZoom: 4,
        maxZoom: 18,
        center: center,
        zoom: zoom,
        rotation: 0,
        nonRotatedSize: math.Point<double>(400, 800),
      );

  @override
  bool move(LatLng newCenter, double newZoom, {Offset? offset, String? id}) {
    center = newCenter;
    zoom = newZoom;
    moveCount++;
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MapFollowingController', () {
    testWidgets('initial state is following', (tester) async {
      final mock = MockMapController();
      final vsync = const TestVSync();
      final controller = MapFollowingController(mapController: mock, vsync: vsync);

      expect(controller.isFollowing, isTrue);
    });

    testWidgets('ignores tiny movements under 3 meter threshold', (tester) async {
      final mock = MockMapController();
      final vsync = const TestVSync();
      final controller = MapFollowingController(mapController: mock, vsync: vsync);

      final initial = const LatLng(23.8103, 90.4125);
      controller.onLocationUpdate(initial);
      expect(mock.moveCount, 1);
      expect(mock.center, initial);

      // Move 1 meter (approx 0.000009 deg)
      final smallMove = const LatLng(23.810309, 90.4125);
      controller.onLocationUpdate(smallMove);
      // Ignored because under 3 meters
      expect(mock.moveCount, 1);
      expect(mock.center, initial);

      // Move 10 meters (approx 0.00009 deg)
      final validMove = const LatLng(23.81039, 90.4125);
      controller.onLocationUpdate(validMove);
      expect(mock.moveCount, 2);
      expect(mock.center, validMove);
    });

    testWidgets('user gesture disables follow, recenter restores follow', (tester) async {
      final mock = MockMapController();
      final vsync = const TestVSync();
      final controller = MapFollowingController(mapController: mock, vsync: vsync);

      expect(controller.isFollowing, isTrue);

      // User drags map
      controller.onUserManualGesture();
      expect(controller.isFollowing, isFalse);

      // GPS updates arrive while user has panned: map does not move
      final loc = const LatLng(23.8200, 90.4200);
      controller.onLocationUpdate(loc);
      expect(mock.center, isNot(loc));

      // User presses "Follow Me"
      controller.recenter(loc);
      expect(controller.isFollowing, isTrue);
      await tester.pumpAndSettle();
      controller.dispose();
    });
  });
}
