class AppConstants {
  static const String appName = 'Journiq';
  static const String appTagline = 'Track Every Journey.';
  static const String appPackageName = 'com.journiq.app';
  static const String userAgent = 'JourniqApp/1.0.0 (contact: support@journiq.app)';
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String osmAttribution = '© OpenStreetMap contributors';

  // Quality filter thresholds
  static const double maxAccuracyMeters = 25.0; // Filter points with poor accuracy
  static const int maxTimestampAgeSeconds = 15; // Ignore stale cached locations
  static const double minMovementMeters = 3.0; // Dwell threshold
  static const double maxAllowedDwellSpeedKmh = 1.0; // Jitter suppression
  static const double maxFutureTimestampSeconds = 5.0;
  static const double minSampleIntervalSeconds = 0.2;
  static const int speedSmoothingWindow = 3;
  static const double speedEmaAlpha = 0.55;

  // Reverse geocoding sampling distance in meters
  static const double geocodingSamplingDistanceMeters = 1500.0; // 1.5 km
}
