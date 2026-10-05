import 'dart:io';
import 'package:geolocator/geolocator.dart';
import '../../domain/models/tracking_point.dart';

abstract class ILocationService {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<bool> openLocationSettings();
  Future<bool> openAppSettings();
  Future<TrackingPoint> getCurrentPosition();
  Stream<TrackingPoint> getPositionStream({
    String notificationTitle = 'Journiq • Journey Active',
    String notificationText = 'Tracking your journey in background',
  });
}

class GeolocatorLocationService implements ILocationService {
  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<TrackingPoint> getCurrentPosition() async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 12),
      ),
    );

    return TrackingPoint(
      latitude: pos.latitude,
      longitude: pos.longitude,
      timestamp: pos.timestamp,
      speedKmh: pos.speed >= 0 ? pos.speed * 3.6 : 0.0,
      accuracyMeters: pos.accuracy,
      heading: pos.heading >= 0 ? pos.heading : null,
    );
  }

  @override
  Stream<TrackingPoint> getPositionStream({
    String notificationTitle = 'Journiq • Journey Active',
    String notificationText = 'Tracking your journey in background',
  }) {
    LocationSettings settings;

    if (Platform.isAndroid) {
      settings = AndroidSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2, // 2 meters
        intervalDuration: const Duration(seconds: 1),
        foregroundNotificationConfig: ForegroundNotificationConfig(
          notificationTitle: notificationTitle,
          notificationText: notificationText,
          notificationIcon: const AndroidResource(
            name: 'ic_launcher',
            defType: 'mipmap',
          ),
          enableWakeLock: true,
        ),
      );
    } else {
      settings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2,
      );
    }

    return Geolocator.getPositionStream(locationSettings: settings).map(
      (pos) => TrackingPoint(
        latitude: pos.latitude,
        longitude: pos.longitude,
        timestamp: pos.timestamp,
        speedKmh: pos.speed >= 0 ? pos.speed * 3.6 : 0.0,
        accuracyMeters: pos.accuracy,
        heading: pos.heading >= 0 ? pos.heading : null,
      ),
    );
  }
}
