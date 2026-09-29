class AppFailure {
  final String message;
  final Object? error;

  const AppFailure(this.message, [this.error]);

  @override
  String toString() => message;
}

class LocationFailure extends AppFailure {
  const LocationFailure(super.message, [super.error]);
}

class PermissionFailure extends AppFailure {
  const PermissionFailure(super.message, [super.error]);
}

class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message, [super.error]);
}

class WeatherFailure extends AppFailure {
  const WeatherFailure(super.message, [super.error]);
}

class GeocodingFailure extends AppFailure {
  const GeocodingFailure(super.message, [super.error]);
}
