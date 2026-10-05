import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/tracking_point.dart';

class CurrentLocationMarker {
  static List<CircleMarker> buildAccuracyCircle(TrackingPoint? point) {
    if (point == null) return [];

    return [
      CircleMarker(
        point: point.toLatLng(),
        radius: point.accuracyMeters.clamp(5.0, 45.0),
        useRadiusInMeter: false,
        color: AppColors.primaryNeon.withValues(alpha: 0.10),
        borderColor: AppColors.primaryNeon.withValues(alpha: 0.35),
        borderStrokeWidth: 1.2,
      ),
    ];
  }

  static Marker buildMarker(TrackingPoint? point) {
    if (point == null) {
      return const Marker(
        point: LatLng(0, 0),
        width: 0,
        height: 0,
        child: SizedBox.shrink(),
      );
    }

    return Marker(
      point: point.toLatLng(),
      width: 44,
      height: 44,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Soft subtle outer glow/pulse
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryNeon.withValues(alpha: 0.18),
              ),
            ),
            // Crisp high-contrast white border disc
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
            // Futuristic vibrant electric cyan center
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryNeon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String formatAccuracyStatus(double accuracyMeters) {
    if (accuracyMeters <= 0) return 'GPS searching';
    if (accuracyMeters <= 8)
      return '±${accuracyMeters.toStringAsFixed(0)} m • Excellent';
    if (accuracyMeters <= 15)
      return '±${accuracyMeters.toStringAsFixed(0)} m • Good';
    if (accuracyMeters <= 25)
      return '±${accuracyMeters.toStringAsFixed(0)} m • Fair';
    return '±${accuracyMeters.toStringAsFixed(0)} m • Weak';
  }
}
