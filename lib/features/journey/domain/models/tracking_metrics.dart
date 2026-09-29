import 'package:latlong2/latlong.dart';
import 'journey_mode.dart';
import 'tracking_point.dart';
import 'tracking_state.dart';

class TrackingMetrics {
  final String? journeyId;
  final JourneyMode mode;
  final TrackingStatus status;
  final double distanceMeters;
  final int activeDurationSeconds;
  final double currentSpeedKmh;
  final double averageSpeedKmh;
  final double maxSpeedKmh;
  final double gpsAccuracyMeters;
  final double? heading;
  final TrackingPoint? currentPoint;
  final List<TrackingPoint> points;
  final String? errorMessage;

  const TrackingMetrics({
    this.journeyId,
    this.mode = JourneyMode.walking,
    this.status = TrackingStatus.idle,
    this.distanceMeters = 0.0,
    this.activeDurationSeconds = 0,
    this.currentSpeedKmh = 0.0,
    this.averageSpeedKmh = 0.0,
    this.maxSpeedKmh = 0.0,
    this.gpsAccuracyMeters = 0.0,
    this.heading,
    this.currentPoint,
    this.points = const [],
    this.errorMessage,
  });

  LatLng? get currentLatLng => currentPoint?.toLatLng();

  List<LatLng> get routeCoordinates =>
      points.map((p) => p.toLatLng()).toList(growable: false);

  TrackingMetrics copyWith({
    String? journeyId,
    JourneyMode? mode,
    TrackingStatus? status,
    double? distanceMeters,
    int? activeDurationSeconds,
    double? currentSpeedKmh,
    double? averageSpeedKmh,
    double? maxSpeedKmh,
    double? gpsAccuracyMeters,
    double? heading,
    TrackingPoint? currentPoint,
    List<TrackingPoint>? points,
    String? errorMessage,
  }) {
    return TrackingMetrics(
      journeyId: journeyId ?? this.journeyId,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      activeDurationSeconds:
          activeDurationSeconds ?? this.activeDurationSeconds,
      currentSpeedKmh: currentSpeedKmh ?? this.currentSpeedKmh,
      averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      gpsAccuracyMeters: gpsAccuracyMeters ?? this.gpsAccuracyMeters,
      heading: heading ?? this.heading,
      currentPoint: currentPoint ?? this.currentPoint,
      points: points ?? this.points,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
