import 'package:intl/intl.dart';

class Formatters {
  /// Format duration in seconds to HH:mm:ss or mm:ss
  static String formatDuration(int seconds) {
    if (seconds < 0) seconds = 0;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = remainingSeconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final hStr = hours.toString().padLeft(2, '0');
      return '$hStr:$mStr:$sStr';
    }
    return '$mStr:$sStr';
  }

  /// Format distance from meters to either "XXX m" or "X.XX km"
  static String formatDistance(double meters) {
    if (meters < 0) meters = 0;
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    }
    return '${(meters / 1000).toStringAsFixed(2)} km';
  }

  /// Format speed in km/h
  static String formatSpeed(double kmh) {
    if (kmh < 0) kmh = 0;
    return '${kmh.toStringAsFixed(1)} km/h';
  }

  /// Format date (e.g., "28 Sep 2026")
  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  /// Format time (e.g., "05:42 PM")
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format full timestamp (e.g., "28 Sep 2026, 05:42 PM")
  static String formatDateTime(DateTime date) {
    return DateFormat('d MMM yyyy, hh:mm a').format(date);
  }
}
