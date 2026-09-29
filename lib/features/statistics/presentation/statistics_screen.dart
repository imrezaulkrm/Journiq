import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../journey/domain/models/journey_mode.dart';
import '../providers/statistics_provider.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statisticsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Travel Insights'),
      ),
      body: statsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryNeon),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (stats) {
          if (stats.totalJourneys == 0) {
            return const EmptyStateView(
              icon: Icons.insights_rounded,
              title: 'No statistics yet.',
              description:
                  'Complete a journey to start building your personal travel insights.',
            );
          }

          final now = DateTime.now();
          final currentMonthName = Formatters.formatDate(now).split(' ')[1]; // e.g. "Sep"
          final currentYearMonth = '$currentMonthName ${now.year}';

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // Lifetime Overview Cards
              Text('Lifetime Mobility', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: FuturisticCard(
                      child: _statTile(
                        'TOTAL DISTANCE',
                        Formatters.formatDistance(stats.totalDistanceMeters),
                        highlightColor: AppColors.primaryNeon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FuturisticCard(
                      child: _statTile(
                        'TOTAL JOURNEYS',
                        '${stats.totalJourneys}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: FuturisticCard(
                      child: _statTile(
                        'ACTIVE TIME',
                        Formatters.formatDuration(stats.totalActiveSeconds),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FuturisticCard(
                      child: _statTile(
                        'AVG DISTANCE',
                        Formatters.formatDistance(stats.averageDistanceMeters),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: FuturisticCard(
                      child: _statTile(
                        'AVG SPEED',
                        Formatters.formatSpeed(stats.averageSpeedKmh),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FuturisticCard(
                      child: _statTile(
                        'MAX SPEED',
                        Formatters.formatSpeed(stats.maxSpeedKmh),
                        highlightColor: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              FuturisticCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Longest Single Journey',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
                    ),
                    Text(
                      Formatters.formatDistance(stats.longestDistanceMeters),
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.accentAmber,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Strict Current Month Section (Section 40)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('This Month', style: AppTypography.titleMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.darkSurfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.darkBorder),
                    ),
                    child: Text(
                      currentYearMonth,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryNeon,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: FuturisticCard(
                      child: _statTile(
                        'MONTH DISTANCE',
                        Formatters.formatDistance(stats.monthDistanceMeters),
                        highlightColor: AppColors.primaryNeon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FuturisticCard(
                      child: _statTile(
                        'MONTH TRIPS',
                        '${stats.monthJourneys}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // By Transport Mode (Section 41)
              Text('Mobility by Mode', style: AppTypography.titleMedium),
              const SizedBox(height: 12),

              ...JourneyMode.values.map((mode) {
                final modeData = stats.modeStats[mode] ?? (count: 0, distanceMeters: 0.0);
                if (modeData.count == 0) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FuturisticCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.darkSurfaceElevated,
                          child: Icon(mode.icon, color: AppColors.primaryNeon, size: 18),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mode.label, style: AppTypography.titleMedium),
                              Text(
                                '${modeData.count} ${modeData.count == 1 ? "journey" : "journeys"}',
                                style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          Formatters.formatDistance(modeData.distanceMeters),
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.primaryNeon,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _statTile(String label, String value, {Color? highlightColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.displayMetric.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: highlightColor ?? AppColors.textPrimaryDark,
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
