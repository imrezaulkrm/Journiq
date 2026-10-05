import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DistanceUnit { km, miles }

enum SpeedUnit { kmh, mph }

class UserSettings {
  final ThemeMode themeMode;
  final DistanceUnit distanceUnit;
  final SpeedUnit speedUnit;

  const UserSettings({
    this.themeMode = ThemeMode.dark,
    this.distanceUnit = DistanceUnit.km,
    this.speedUnit = SpeedUnit.kmh,
  });

  UserSettings copyWith({
    ThemeMode? themeMode,
    DistanceUnit? distanceUnit,
    SpeedUnit? speedUnit,
  }) {
    return UserSettings(
      themeMode: themeMode ?? this.themeMode,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      speedUnit: speedUnit ?? this.speedUnit,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, UserSettings>((
  ref,
) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<UserSettings> {
  static const _keyTheme = 'settings.theme';
  static const _keyDistance = 'settings.distance';
  static const _keySpeed = 'settings.speed';

  SettingsNotifier() : super(const UserSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_keyTheme);
    final distanceIndex = prefs.getInt(_keyDistance);
    final speedIndex = prefs.getInt(_keySpeed);

    state = UserSettings(
      themeMode: themeIndex != null && themeIndex < ThemeMode.values.length
          ? ThemeMode.values[themeIndex]
          : ThemeMode.dark,
      distanceUnit:
          distanceIndex != null && distanceIndex < DistanceUnit.values.length
          ? DistanceUnit.values[distanceIndex]
          : DistanceUnit.km,
      speedUnit: speedIndex != null && speedIndex < SpeedUnit.values.length
          ? SpeedUnit.values[speedIndex]
          : SpeedUnit.kmh,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTheme, mode.index);
  }

  Future<void> setDistanceUnit(DistanceUnit unit) async {
    state = state.copyWith(distanceUnit: unit);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDistance, unit.index);
  }

  Future<void> setSpeedUnit(SpeedUnit unit) async {
    state = state.copyWith(speedUnit: unit);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySpeed, unit.index);
  }
}
