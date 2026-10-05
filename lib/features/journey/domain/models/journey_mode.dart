import 'package:flutter/material.dart';

enum JourneyMode { walking, bicycle, motorcycle, car, bus, train, other }

extension JourneyModeX on JourneyMode {
  String get label {
    switch (this) {
      case JourneyMode.walking:
        return 'Walking';
      case JourneyMode.bicycle:
        return 'Bicycle';
      case JourneyMode.motorcycle:
        return 'Motorcycle';
      case JourneyMode.car:
        return 'Car';
      case JourneyMode.bus:
        return 'Bus';
      case JourneyMode.train:
        return 'Train';
      case JourneyMode.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case JourneyMode.walking:
        return Icons.directions_walk_rounded;
      case JourneyMode.bicycle:
        return Icons.directions_bike_rounded;
      case JourneyMode.motorcycle:
        return Icons.two_wheeler_rounded;
      case JourneyMode.car:
        return Icons.directions_car_rounded;
      case JourneyMode.bus:
        return Icons.directions_bus_rounded;
      case JourneyMode.train:
        return Icons.train_rounded;
      case JourneyMode.other:
        return Icons.explore_rounded;
    }
  }

  /// Maximum realistic speed threshold in km/h for GPS sanity check per mode
  double get maxPlausibleSpeedKmh {
    switch (this) {
      case JourneyMode.walking:
        return 22.0; // Fast sprint / jog
      case JourneyMode.bicycle:
        return 65.0; // Fast descent / road cycling
      case JourneyMode.motorcycle:
        return 170.0;
      case JourneyMode.car:
        return 190.0;
      case JourneyMode.bus:
        return 130.0;
      case JourneyMode.train:
        return 260.0; // High speed rail
      case JourneyMode.other:
        return 180.0;
    }
  }

  static JourneyMode fromIndex(int index) {
    if (index >= 0 && index < JourneyMode.values.length) {
      return JourneyMode.values[index];
    }
    return JourneyMode.other;
  }
}
