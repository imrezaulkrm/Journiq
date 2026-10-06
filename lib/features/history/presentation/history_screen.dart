import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../journey/domain/models/journey_mode.dart';
import '../../journey/presentation/screens/mode_selection_sheet.dart';
import '../../journey/presentation/screens/live_journey_screen.dart';
import '../../journey/providers/tracking_provider.dart';
import '../providers/history_provider.dart';
import 'journey_detail_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final journeysAsync = ref.watch(allJourneysProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Journey History')),
      body: journeysAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryNeon),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (journeys) {
          if (journeys.isEmpty) {
            return EmptyStateView(
              icon: Icons.history_rounded,
              title: 'No journeys yet.',
              description:
                  'Your journeys will appear here after you complete your first trip.',
              actionLabel: 'Start Journey',
              onAction: () async {
                final mode = await ModeSelectionSheet.show(context);
                if (mode != null && context.mounted) {
                  final started = await ref
                      .read(trackingProvider.notifier)
                      .startJourney(mode);
                  if (started && context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LiveJourneyScreen(),
                      ),
                    );
                  }
                }
              },
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: journeys.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final j = journeys[index];
              final mode = JourneyModeX.fromIndex(j.mode);

              List<String> areas = [];
              try {
                areas = (jsonDecode(j.areasCovered) as List).cast<String>();
              } catch (_) {}

              final areaSummary = areas.isNotEmpty
                  ? (areas.length > 2
                        ? '${areas.first} → ${areas.last}'
                        : areas.join(' • '))
                  : null;

              return FuturisticCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => JourneyDetailScreen(journeyId: j.id),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: isDark
                          ? AppColors.darkSurfaceElevated
                          : AppColors.lightSurfaceElevated,
                      child: Icon(
                        mode.icon,
                        color: AppColors.primaryNeon,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                mode.label,
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                Formatters.formatDistance(j.distanceMeters),
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.primaryNeon,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${Formatters.formatDuration(j.activeDurationSeconds)} • Avg ${Formatters.formatSpeed(j.averageSpeedKmh)}',
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Formatters.formatDateTime(j.startTime),
                                style: AppTypography.labelSmall.copyWith(
                                  color: isDark
                                      ? AppColors.textMutedDark
                                      : AppColors.textMutedLight,
                                  fontSize: 10,
                                ),
                              ),
                              if (areaSummary != null)
                                Flexible(
                                  child: Text(
                                    areaSummary,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primaryTeal,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondaryDark,
                      size: 20,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
