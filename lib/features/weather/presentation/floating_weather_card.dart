import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/futuristic_card.dart';
import '../domain/models/weather_snapshot.dart';

class FloatingWeatherCard extends StatefulWidget {
  final WeatherSnapshot? weather;

  const FloatingWeatherCard({
    super.key,
    required this.weather,
  });

  @override
  State<FloatingWeatherCard> createState() => _FloatingWeatherCardState();
}

class _FloatingWeatherCardState extends State<FloatingWeatherCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final w = widget.weather;

    if (w == null) {
      return FuturisticCard(
        enableGlass: true,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 16, color: AppColors.statusOrange),
            const SizedBox(width: 8),
            Text(
              'Weather unavailable • Tracking unaffected',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          ],
        ),
      );
    }

    return FuturisticCard(
      enableGlass: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.water_drop_rounded,
                  size: 16,
                  color: AppColors.primaryNeon,
                ),
                const SizedBox(width: 6),
                Text(
                  '${w.rainProbability}%',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primaryNeon,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${w.temperature.toStringAsFixed(0)}°C • ${w.condition}',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: AppColors.textSecondaryDark,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              w.rainOutlookMessage,
              style: AppTypography.labelSmall.copyWith(
                color: w.rainProbability >= 40
                    ? AppColors.statusOrange
                    : AppColors.textSecondaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Text(
                'Next ~2 Hours Rain Outlook',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                w.rainProgressionString,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryNeon,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Humidity: ${w.humidity}%',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Wind: ${w.windSpeedKmh.toStringAsFixed(1)} km/h',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
