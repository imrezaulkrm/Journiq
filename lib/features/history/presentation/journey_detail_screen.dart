import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../journey/domain/models/journey_mode.dart';
import '../../journey/providers/tracking_provider.dart';
import '../../offline_map/data/offline_tile_provider.dart';
import '../../offline_map/providers/offline_map_provider.dart';
import '../providers/history_provider.dart';

class JourneyDetailScreen extends ConsumerWidget {
  final String journeyId;

  const JourneyDetailScreen({super.key, required this.journeyId});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
        title: const Text('Delete this journey?'),
        content: const Text(
          'This will permanently remove the journey information, route points, weather snapshot, and areas covered from local storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.statusRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final repo = ref.read(journeyRepositoryProvider);
      await repo.deleteJourney(journeyId);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(journeyDetailProvider(journeyId));
    final storage = ref.watch(offlineStorageProvider);
    final mapMode = ref.watch(mapModeProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Journey Details'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.statusRed,
            ),
            onPressed: () => _confirmDelete(context, ref),
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
          final points = data.points.map((p) => p.toLatLng()).toList();
          final mapCenter = points.isNotEmpty
              ? points[points.length ~/ 2]
              : const LatLng(23.8103, 90.4125);

          List<String> areas = [];
          try {
            areas = (jsonDecode(j.areasCovered) as List).cast<String>();
          } catch (_) {}

          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              // Full Route Map Preview
              SizedBox(
                height: 280,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: mapCenter,
                    initialZoom: 14.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: AppConstants.osmTileUrl,
                      userAgentPackageName: AppConstants.appPackageName,
                      tileProvider: JourniqTileProvider(
                        storage: storage,
                        mode: mapMode,
                        baseStoragePath: storage.cachedBasePath,
                      ),
                    ),
                    if (points.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: points,
                            strokeWidth: 5.0,
                            color: AppColors.primaryNeon,
                          ),
                        ],
                      ),
                    if (points.isNotEmpty)
                      MarkerLayer(
                        markers: [
                          // Start pin
                          Marker(
                            point: points.first,
                            width: 28,
                            height: 28,
                            child: const CircleAvatar(
                              backgroundColor: AppColors.statusGreen,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                size: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // End pin
                          Marker(
                            point: points.last,
                            width: 28,
                            height: 28,
                            child: const CircleAvatar(
                              backgroundColor: AppColors.statusRed,
                              child: Icon(
                                Icons.stop_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primaryNeon.withValues(
                            alpha: 0.18,
                          ),
                          child: Icon(mode.icon, color: AppColors.primaryNeon),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mode.label,
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              Formatters.formatDateTime(j.startTime),
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Metrics Grid
                    FuturisticCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _metricBox(
                                'DISTANCE',
                                Formatters.formatDistance(j.distanceMeters),
                              ),
                              Container(
                                height: 36,
                                width: 1,
                                color: AppColors.darkBorder,
                              ),
                              _metricBox(
                                'DURATION',
                                Formatters.formatDuration(
                                  j.activeDurationSeconds,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _metricBox(
                                'AVG SPEED',
                                Formatters.formatSpeed(j.averageSpeedKmh),
                              ),
                              Container(
                                height: 36,
                                width: 1,
                                color: AppColors.darkBorder,
                              ),
                              _metricBox(
                                'MAX SPEED',
                                Formatters.formatSpeed(j.maxSpeedKmh),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Time details
                    FuturisticCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Started',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondaryDark,
                                ),
                              ),
                              Text(
                                Formatters.formatTime(j.startTime),
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Finished',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondaryDark,
                                ),
                              ),
                              Text(
                                Formatters.formatTime(j.endTime),
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Weather card if present
                    if (j.weatherTemperature != null) ...[
                      FuturisticCard(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.wb_sunny_rounded,
                              color: AppColors.accentAmber,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${j.weatherTemperature?.toStringAsFixed(0)}°C • ${j.weatherCondition ?? "Fair"}',
                                  style: AppTypography.titleMedium,
                                ),
                                Text(
                                  'Rain: ${j.weatherRainProbability ?? 0}% • Wind: ${j.weatherWindSpeed?.toStringAsFixed(1) ?? "0"} km/h',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Areas Covered
                    FuturisticCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Areas Covered',
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: 8),
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
                              children: areas.map((a) {
                                return Chip(
                                  backgroundColor:
                                      AppColors.darkSurfaceElevated,
                                  side: const BorderSide(
                                    color: AppColors.darkBorder,
                                  ),
                                  label: Text(
                                    a,
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
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _metricBox(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.largeMetric.copyWith(
            fontWeight: FontWeight.w800,
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
