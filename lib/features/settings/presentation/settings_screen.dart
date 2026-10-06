import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/app_version_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../offline_map/presentation/offline_maps_screen.dart';
import '../../offline_map/providers/offline_map_provider.dart';
import '../providers/settings_provider.dart';

import '../../update/data/app_update_service.dart';
import '../../update/domain/update_info.dart';
import '../../update/presentation/update_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double _dbSizeMb = 0.0;
  bool _isCheckingUpdate = false;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _calcDbSize();
  }

  Future<void> _loadAppVersion() async {
    final version = await AppVersionService.version;

    if (!mounted) return;

    setState(() {
      _appVersion = version;
    });
  }

  Future<void> _checkForUpdate() async {
    setState(() => _isCheckingUpdate = true);
    final service = AppUpdateService(
      currentVersion: _appVersion,
      configurationUri: Uri.parse(AppConstants.defaultUpdateUrl),
    );

    try {
      final info = await service.check(force: true);
      if (!mounted) return;
      setState(() => _isCheckingUpdate = false);

      if (info == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not reach update server. Check internet connection.',
            ),
          ),
        );
        return;
      }

      final req = info.requirementFor(_appVersion);
      if (req != UpdateRequirement.none) {
        UpdateDialog.show(context, info: info, currentVersion: _appVersion);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.statusGreen,
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Journiq is up to date (v$_appVersion).',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isCheckingUpdate = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to check for updates.')),
        );
      }
    }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsProvider);
    final offlineState = ref.watch(offlineMapControllerProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
                    Icon(
                      Icons.palette_outlined,
                      color: AppColors.primaryNeon,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Text('Theme Mode'),
                  ],
                ),
                DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  dropdownColor: isDark
                      ? AppColors.darkSurfaceElevated
                      : AppColors.lightSurfaceElevated,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Futuristic Dark'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Clean Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System Default'),
                    ),
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
                        Icon(
                          Icons.straighten_rounded,
                          color: AppColors.primaryNeon,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Text('Distance'),
                      ],
                    ),
                    Text(
                      'Kilometres (km)',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          color: AppColors.primaryNeon,
                          size: 22,
                        ),
                        SizedBox(width: 12),
                        Text('Speed'),
                      ],
                    ),
                    Text(
                      'Kilometres per hour (km/h)',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
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
                    Icon(
                      Icons.download_for_offline_outlined,
                      color: AppColors.primaryNeon,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Offline District Maps'),
                        Text(
                          'Download regional maps for offline navigation',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondaryDark,
                ),
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
                    Text(
                      'SQLite Drift Database',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    Text(
                      '${_dbSizeMb.toStringAsFixed(2)} MB',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Offline Map Tiles',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    Text(
                      '${offlineState.totalStorageMb.toStringAsFixed(1)} MB',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryNeon,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // App Updates Section
          Text('App Version & Updates', style: AppTypography.titleMedium),
          const SizedBox(height: 8),
          FuturisticCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          color: AppColors.primaryNeon,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppConstants.appName,
                              style: AppTypography.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _isCheckingUpdate ? null : _checkForUpdate,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: _isCheckingUpdate
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.sync_rounded, size: 16),
                      label: Text(
                        _isCheckingUpdate ? 'Checking...' : 'Check Updates',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                const Icon(
                  Icons.shield_outlined,
                  color: AppColors.statusGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100% Local-First',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Journiq stores all your journeys, GPS points, routes, and statistics locally on your device in a secure SQLite database. No accounts, no cloud servers, and no tracking telemetry.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About Card
          Center(
            child: Column(
              children: [
                Text(
                  // '${AppConstants.appName} v$_appVersion',
                  AppConstants.appName,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  AppConstants.appTagline,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
