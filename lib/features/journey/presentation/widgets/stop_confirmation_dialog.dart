import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';

class StopConfirmationDialog extends StatelessWidget {
  final double distanceMeters;
  final int activeDurationSeconds;
  final double averageSpeedKmh;
  final double maxSpeedKmh;

  const StopConfirmationDialog({
    super.key,
    required this.distanceMeters,
    required this.activeDurationSeconds,
    required this.averageSpeedKmh,
    required this.maxSpeedKmh,
  });

  static Future<bool?> show(
    BuildContext context, {
    required double distanceMeters,
    required int activeDurationSeconds,
    required double averageSpeedKmh,
    required double maxSpeedKmh,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StopConfirmationDialog(
        distanceMeters: distanceMeters,
        activeDurationSeconds: activeDurationSeconds,
        averageSpeedKmh: averageSpeedKmh,
        maxSpeedKmh: maxSpeedKmh,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.darkBorder, width: 1),
      ),
      title: Text(
        'End Journey?',
        style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your route and travel insights will be saved locally on this device.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 20),
          _metricRow('Distance', Formatters.formatDistance(distanceMeters)),
          const SizedBox(height: 8),
          _metricRow(
            'Active Time',
            Formatters.formatDuration(activeDurationSeconds),
          ),
          const SizedBox(height: 8),
          _metricRow('Avg Speed', Formatters.formatSpeed(averageSpeedKmh)),
          const SizedBox(height: 8),
          _metricRow('Max Speed', Formatters.formatSpeed(maxSpeedKmh)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Continue Journey'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.statusRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('End & Save'),
        ),
      ],
    );
  }

  Widget _metricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondaryDark,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryDark,
          ),
        ),
      ],
    );
  }
}
