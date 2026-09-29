import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../models/journey_mode.dart';
import '../models/tracking_point.dart';

/// Derives movement speed from consecutive quality-checked coordinates.
/// The device-reported speed is deliberately not used for the result.
class ValidatedSpeedCalculator {
  final JourneyMode mode;
  final List<double> _recent = <double>[];
  double _ema = 0;

  ValidatedSpeedCalculator(this.mode);

  double get lastSpeedKmh => _ema;

  void reset() {
    _recent.clear();
    _ema = 0;
  }

  void decayStationary() {
    _recent.clear();
    _recent.add(0.0);
    _ema *= 0.35;
    if (_ema < 0.2) _ema = 0.0;
  }

  double calculate({required TrackingPoint previous, required TrackingPoint current}) {
    final seconds = current.timestamp.difference(previous.timestamp).inMilliseconds / 1000.0;
    if (seconds <= 0) return _ema;

    final meters = DistanceCalculator.haversineDistanceMeters(
      previous.latitude,
      previous.longitude,
      current.latitude,
      current.longitude,
    );

    final raw = (meters / seconds) * 3.6;
    final stationary = meters < AppConstants.minMovementMeters && raw < AppConstants.maxAllowedDwellSpeedKmh;
    final bounded = stationary ? 0.0 : raw.clamp(0.0, mode.maxPlausibleSpeedKmh).toDouble();

    _recent.add(bounded);
    if (_recent.length > AppConstants.speedSmoothingWindow) {
      _recent.removeAt(0);
    }

    final sorted = List<double>.of(_recent)..sort();
    final median = sorted[sorted.length ~/ 2];

    _ema = _ema == 0 ? median : (_ema * (1 - AppConstants.speedEmaAlpha)) + (median * AppConstants.speedEmaAlpha);

    if (stationary) {
      _ema *= 0.35;
    }
    if (_ema < 0.2) {
      _ema = 0;
    }
    return _ema;
  }
}
