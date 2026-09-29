import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../domain/models/tracking_metrics.dart';
import '../../domain/models/journey_mode.dart';
import '../../domain/models/tracking_state.dart';
import 'current_location_marker.dart';

class LiveMetricsPanel extends StatelessWidget {
  final TrackingMetrics metrics;
  final VoidCallback onPauseResume;
  final VoidCallback onStop;

  const LiveMetricsPanel({
    super.key,
    required this.metrics,
    required this.onPauseResume,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final isPaused = metrics.status.isPaused;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Paused Banner if tracking is paused
        if (isPaused)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.statusOrange.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.statusOrange, width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.pause_circle_filled_rounded, size: 16, color: AppColors.statusOrange),
                const SizedBox(width: 6),
                Text(
                  'PAUSED • Tracking temporarily halted',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.statusOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

        // Main Floating Metric Panel (iOS-style translucent rounded card)
        FuturisticCard(
          enableGlass: true,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Status Row: Transport Mode & GPS Accuracy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNeon.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryNeon.withValues(alpha: 0.25), width: 0.8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          metrics.mode.icon,
                          size: 14,
                          color: AppColors.primaryNeon,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          metrics.mode.label.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.primaryNeon,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 0.6,
                      ),
                    ),
                    child: Text(
                      CurrentLocationMarker.formatAccuracyStatus(metrics.gpsAccuracyMeters),
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Prominent Primary Speed Focus (Section 10 Hierarchy)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CURRENT SPEED',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      letterSpacing: 1.0,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        metrics.currentSpeedKmh.toStringAsFixed(1),
                        style: AppTypography.displayMetric.copyWith(
                          color: AppColors.primaryNeon,
                          fontWeight: FontWeight.w800,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'km/h',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Secondary Metrics Row: Distance | Active Time | Avg Speed
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceElevated.withValues(alpha: 0.5) : AppColors.lightSurfaceElevated.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _subMetric(
                      label: 'Distance',
                      value: Formatters.formatDistance(metrics.distanceMeters),
                      isDark: isDark,
                    ),
                    Container(height: 24, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    _subMetric(
                      label: 'Active Time',
                      value: Formatters.formatDuration(metrics.activeDurationSeconds),
                      isDark: isDark,
                    ),
                    Container(height: 24, width: 1, color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    _subMetric(
                      label: 'Avg Speed',
                      value: Formatters.formatSpeed(metrics.averageSpeedKmh),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Action Buttons: Pause / Resume + Stop
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onPauseResume,
                      style: FilledButton.styleFrom(
                        backgroundColor: isPaused
                            ? AppColors.primaryTeal
                            : (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated),
                        foregroundColor: isPaused ? Colors.black : (isDark ? Colors.white : Colors.black87),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isPaused
                                ? AppColors.primaryTeal
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            width: 0.8,
                          ),
                        ),
                      ),
                      icon: Icon(
                        isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        size: 20,
                      ),
                      label: Text(
                        isPaused ? 'Resume' : 'Pause',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onStop,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.statusRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.stop_rounded, size: 20),
                      label: const Text(
                        'Stop',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _subMetric({
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
