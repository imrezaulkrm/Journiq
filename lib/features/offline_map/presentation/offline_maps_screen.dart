import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/district_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../data/offline_tile_provider.dart';
import '../domain/models/district_model.dart';
import '../providers/offline_map_provider.dart';

class OfflineMapsScreen extends ConsumerWidget {
  const OfflineMapsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offlineState = ref.watch(offlineMapControllerProvider);
    final mapMode = ref.watch(mapModeProvider);
    final controller = ref.read(offlineMapControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(title: const Text('Offline Maps')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Map Mode Selector Card
          Text('Map Provider Mode', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          FuturisticCard(
            child: RadioGroup<MapMode>(
              groupValue: mapMode,
              onChanged: (val) {
                if (val != null) ref.read(mapModeProvider.notifier).state = val;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<MapMode>(
                    title: const Text('Automatic Mode'),
                    subtitle: Text(
                      'Prefers downloaded offline maps and falls back to online data.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    value: MapMode.automatic,
                    activeColor: AppColors.primaryNeon,
                  ),
                  RadioListTile<MapMode>(
                    title: const Text('Offline Only Mode'),
                    subtitle: Text(
                      'Only renders cached and downloaded local district tiles.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    value: MapMode.offlineOnly,
                    activeColor: AppColors.primaryNeon,
                  ),
                  RadioListTile<MapMode>(
                    title: const Text('Online Only Mode'),
                    subtitle: Text(
                      'Always stream freshest online tiles from OpenStreetMap.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    value: MapMode.onlineOnly,
                    activeColor: AppColors.primaryNeon,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Total Storage Usage Card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('District Map Packs', style: AppTypography.titleMedium),
              Text(
                'Storage: ${offlineState.totalStorageMb.toStringAsFixed(1)} MB',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primaryNeon,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // District List
          ...DistrictData.districts.map((district) {
            final status =
                offlineState.districtStatuses[district.id] ??
                DistrictMapStatus(
                  districtId: district.id,
                  districtName: district.name,
                );

            final isDownloading = status.status == DownloadStatus.downloading;
            final isCompleted = status.status == DownloadStatus.completed;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FuturisticCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.map_outlined,
                              color: isCompleted
                                  ? AppColors.statusGreen
                                  : AppColors.primaryNeon,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  district.name,
                                  style: AppTypography.titleMedium,
                                ),
                                Text(
                                  'Coverage zoom: ${district.minZoom}–${district.maxZoom}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.textSecondaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (!isDownloading && !isCompleted)
                          FilledButton.icon(
                            onPressed: () => controller.startDownload(district),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.darkSurfaceElevated,
                              foregroundColor: AppColors.primaryNeon,
                              side: const BorderSide(
                                color: AppColors.primaryNeon,
                              ),
                            ),
                            icon: const Icon(Icons.download_rounded, size: 16),
                            label: const Text('Download'),
                          )
                        else if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.statusGreen.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.statusGreen),
                            ),
                            child: Text(
                              '✓ Available Offline',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.statusGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),

                    if (isDownloading) ...[
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: status.progress,
                        backgroundColor: AppColors.darkSurfaceElevated,
                        color: AppColors.primaryNeon,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Downloaded: ${status.downloadedTiles} / ${status.totalTiles} tiles (${(status.progress * 100).toStringAsFixed(0)}%)',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondaryDark,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                controller.cancelDownload(district.id),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: AppColors.statusRed),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          // Cache Clearance Option
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.darkSurface,
                    title: const Text('Clear Offline Map Storage?'),
                    content: const Text(
                      'This will delete all locally cached and downloaded map tiles.',
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
                        ),
                        child: const Text('Clear Storage'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await controller.clearAllStorage();
                }
              },
              icon: const Icon(
                Icons.delete_sweep_rounded,
                color: AppColors.textSecondaryDark,
                size: 18,
              ),
              label: Text(
                'Clear Downloaded Map Cache',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
