import 'package:latlong2/latlong.dart';

class TrackingPoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double speedKmh;
  final double accuracyMeters;
  final double? heading;

  const TrackingPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speedKmh,
    required this.accuracyMeters,
    this.heading,
  });

  LatLng toLatLng() => LatLng(latitude, longitude);

  @override
  String toString() =>
      'TrackingPoint(lat: $latitude, lng: $longitude, speed: $speedKmh km/h, acc: $accuracyMeters m)';
}
