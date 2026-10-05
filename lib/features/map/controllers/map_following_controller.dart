import 'package:flutter/animation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

/// Manages Google Maps-style current-location follow behavior.
///
/// The user's current location marker remains centered on the visible map.
/// When the user moves, the map moves directly underneath the marker.
/// Manual pan/zoom pauses follow without snapping back.
/// "Follow Me" smoothly recenters and restores follow.
class MapFollowingController {
  final MapController mapController;
  final TickerProvider vsync;

  bool isFollowing = true;
  AnimationController? _animController;
  LatLng? _lastTarget;
  static const double _movementThresholdMeters = 3.0;

  MapFollowingController({required this.mapController, required this.vsync});

  void dispose() {
    _animController?.stop();
    _animController?.dispose();
    _animController = null;
  }

  /// Called when user interacts manually with the map (pan, pinch zoom)
  void onUserManualGesture() {
    if (isFollowing) {
      isFollowing = false;
      _animController?.stop();
    }
  }

  static double _distanceMeters(LatLng a, LatLng b) {
    const earthRadius = 6371000.0;
    final p1 = a.latitude * math.pi / 180;
    final p2 = b.latitude * math.pi / 180;
    final dp = (b.latitude - a.latitude) * math.pi / 180;
    final dl = (b.longitude - a.longitude) * math.pi / 180;
    final h =
        math.sin(dp / 2) * math.sin(dp / 2) +
        math.cos(p1) * math.cos(p2) * math.sin(dl / 2) * math.sin(dl / 2);
    return earthRadius * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  /// Restores camera follow mode and animates camera to user's current location
  void recenter(LatLng target, {double? zoom}) {
    isFollowing = true;
    _lastTarget = target;
    final targetZoom = zoom ?? mapController.camera.zoom;
    animateTo(target, zoom: targetZoom);
  }

  /// Smoothly animates camera to target position on manual recenter
  void animateTo(LatLng target, {double? zoom}) {
    _lastTarget = target;
    final currentCenter = mapController.camera.center;
    final currentZoom = mapController.camera.zoom;
    final targetZoom = zoom ?? currentZoom;

    _animController?.stop();
    _animController?.dispose();
    _animController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 350),
    );

    final latTween = Tween<double>(
      begin: currentCenter.latitude,
      end: target.latitude,
    );
    final lngTween = Tween<double>(
      begin: currentCenter.longitude,
      end: target.longitude,
    );
    final zoomTween = Tween<double>(begin: currentZoom, end: targetZoom);

    final curved = CurvedAnimation(
      parent: _animController!,
      curve: Curves.easeOutCubic,
    );

    _animController!.addListener(() {
      final lat = latTween.evaluate(curved);
      final lng = lngTween.evaluate(curved);
      final z = zoomTween.evaluate(curved);
      mapController.move(LatLng(lat, lng), z);
    });

    _animController!.forward();
  }

  /// Automatically called on validated GPS fix.
  /// Direct map recentering keeps marker visually synchronized in center
  /// while the map background moves underneath it.
  void onLocationUpdate(LatLng newLocation) {
    if (!isFollowing) return;

    final previous = _lastTarget;
    // Suppress tiny jitter below threshold to prevent visible map shaking
    if (previous != null &&
        _distanceMeters(previous, newLocation) < _movementThresholdMeters) {
      return;
    }
    // Only update _lastTarget once threshold is satisfied
    _lastTarget = newLocation;

    // Terminate any active animation to avoid conflicting camera movements
    _animController?.stop();
    _animController?.dispose();
    _animController = null;

    // Direct move preserves current zoom level and keeps marker centered
    mapController.move(newLocation, mapController.camera.zoom);
  }
}
