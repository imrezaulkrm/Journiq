import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../offline_map/presentation/offline_maps_screen.dart';
import '../../offline_map/providers/offline_map_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double _dbSizeMb = 0.0;

  @override
  void initState() {
    super.initState();
    _calcDbSize();
  }

  Future<void> _calcDbSize() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final dbFile = File('${docDir.path}/journiq_app_database.sqlite');
      if (await dbFile.exists()) {
        final length = await dbFile.length();
        if (mounted) setState(() => _dbSizeMb = length / (1024 * 1024));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final offlineState = ref.watch(offlineMapControllerProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Theme Settings
          Text('Appearance', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          FuturisticCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.palette_outlined, color: AppColors.primaryNeon, size: 22),
                    SizedBox(width: 12),
                    Text('Theme Mode'),
                  ],
                ),
                DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  dropdownColor: AppColors.darkSurfaceElevated,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: ThemeMode.dark, child: Text('Futuristic Dark')),
                    DropdownMenuItem(value: ThemeMode.light, child: Text('Clean Light')),
                    DropdownMenuItem(value: ThemeMode.system, child: Text('System Default')),
                  ],
                  onChanged: (mode) {
                    if (mode != null) notifier.setThemeMode(mode);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Units Settings
          Text('Measurement Units', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          FuturisticCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.straighten_rounded, color: AppColors.primaryNeon, size: 22),
                        SizedBox(width: 12),
                        Text('Distance'),
                      ],
                    ),
                    Text(
                      'Kilometres (km)',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.speed_rounded, color: AppColors.primaryNeon, size: 22),
                        SizedBox(width: 12),
                        Text('Speed'),
                      ],
                    ),
                    Text(
                      'Kilometres per hour (km/h)',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Map & Offline Data
          Text('Map & Storage Data', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          FuturisticCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OfflineMapsScreen()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.download_for_offline_outlined, color: AppColors.primaryNeon, size: 22),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Offline District Maps'),
                        Text('Download regional maps for offline navigation', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryDark)),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondaryDark),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Storage Statistics
          FuturisticCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Storage Breakdown', style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SQLite Drift Database', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
                    Text(
                      '${_dbSizeMb.toStringAsFixed(2)} MB',
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Offline Map Tiles', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)),
                    Text(
                      '${offlineState.totalStorageMb.toStringAsFixed(1)} MB',
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.primaryNeon),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Privacy Card (Section 61)
          Text('Privacy & Local First', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          FuturisticCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: AppColors.statusGreen, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('100% Local-First', style: AppTypography.titleMedium),
                      const SizedBox(height: 4),
                      Text(
                        'Journiq stores all your journeys, GPS points, routes, and statistics locally on your device in a secure SQLite database. No accounts, no cloud servers, and no tracking telemetry.',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About Card
          Center(
            child: Column(
              children: [
                Text(
                  '${AppConstants.appName} v1.0.0',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  AppConstants.appTagline,
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
