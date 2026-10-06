import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../../history/presentation/journey_detail_screen.dart';
import '../../../history/providers/history_provider.dart';
import '../../domain/models/journey_mode.dart';

class JourneySummaryScreen extends ConsumerWidget {
  final String journeyId;

  const JourneySummaryScreen({super.key, required this.journeyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final detailAsync = ref.watch(journeyDetailProvider(journeyId));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Journey Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: detailAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryNeon),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) {
          final j = data.journey;
          if (j == null) {
            return const Center(child: Text('Journey not found'));
          }

          final mode = JourneyModeX.fromIndex(j.mode);
          List<String> areas = [];
          try {
            areas = (jsonDecode(j.areasCovered) as List).cast<String>();
          } catch (_) {}

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Celebration Header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryNeon.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryNeon,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        size: 40,
                        color: AppColors.primaryNeon,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Journey Complete 🎉',
                      style: AppTypography.displayMetric.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${mode.label} • ${Formatters.formatDate(j.startTime)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Distance & Time Highlight Card
              FuturisticCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          Formatters.formatDistance(j.distanceMeters),
                          style: AppTypography.displayMetric.copyWith(
                            color: AppColors.primaryNeon,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'DISTANCE',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 44,
                      width: 1,
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                    Column(
                      children: [
                        Text(
                          Formatters.formatDuration(j.activeDurationSeconds),
                          style: AppTypography.displayMetric.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ACTIVE TIME',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Speed Metrics Card
              FuturisticCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem(
                      'AVERAGE SPEED',
                      Formatters.formatSpeed(j.averageSpeedKmh),
                    ),
                    Container(
                      height: 36,
                      width: 1,
                      color: AppColors.darkBorder,
                    ),
                    _statItem(
                      'MAXIMUM SPEED',
                      Formatters.formatSpeed(j.maxSpeedKmh),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Weather Snapshot Card
              if (j.weatherTemperature != null) ...[
                FuturisticCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.wb_sunny_rounded,
                        color: AppColors.accentAmber,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${j.weatherTemperature?.toStringAsFixed(0)}°C • ${j.weatherCondition ?? "Fair"}',
                              style: AppTypography.titleMedium,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Rain probability: ${j.weatherRainProbability ?? 0}% • Wind: ${j.weatherWindSpeed?.toStringAsFixed(1) ?? "0"} km/h',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Areas Visited Card
              FuturisticCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Areas Covered', style: AppTypography.titleMedium),
                    const SizedBox(height: 10),
                    if (areas.isEmpty)
                      Text(
                        'Area details unavailable',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondaryDark,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: areas.map((area) {
                          return Chip(
                            backgroundColor: AppColors.darkSurfaceElevated,
                            side: const BorderSide(color: AppColors.darkBorder),
                            label: Text(
                              area,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primaryNeon,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Buttons: View Journey & Done
              FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => JourneyDetailScreen(journeyId: journeyId),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryNeon,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.map_rounded),
                label: const Text(
                  'View Journey on Map',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimaryDark,
                  side: const BorderSide(color: AppColors.darkBorder),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Done'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.largeMetric.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textSecondaryDark,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
