import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../history/presentation/journey_detail_screen.dart';
import '../../history/providers/history_provider.dart';
import '../../journey/domain/models/journey_mode.dart';
import '../../journey/domain/models/tracking_point.dart';
import '../../journey/domain/models/tracking_state.dart';
import '../../journey/presentation/screens/live_journey_screen.dart';
import '../../journey/presentation/widgets/current_location_marker.dart';
import '../../journey/providers/tracking_provider.dart';
import '../../offline_map/data/offline_tile_provider.dart';
import '../../offline_map/providers/offline_map_provider.dart';
import '../../statistics/providers/statistics_provider.dart';
import '../../weather/domain/models/weather_snapshot.dart';
import '../../weather/presentation/floating_weather_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback onNavigateToHistory;

  const HomeScreen({super.key, required this.onNavigateToHistory});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  WeatherSnapshot? _homeWeather;
  TrackingPoint? _currentLocation;
  JourneyMode _selectedMode = JourneyMode.walking;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final loc = ref.read(locationServiceProvider);
      final pt = await loc.getCurrentPosition();
      if (mounted) {
        setState(() => _currentLocation = pt);
      }
      final weatherService = ref.read(weatherServiceProvider);
      final w = await weatherService.getWeather(pt.latitude, pt.longitude);
      if (mounted) setState(() => _homeWeather = w);
    } catch (_) {}
  }

  Future<void> _startTracking(JourneyMode mode) async {
    final started = await ref
        .read(trackingProvider.notifier)
        .startJourney(mode);
    if (started && mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const LiveJourneyScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = ref.watch(trackingProvider);
    final journeysAsync = ref.watch(allJourneysProvider);
    final statsAsync = ref.watch(statisticsProvider);
    final mapMode = ref.watch(mapModeProvider);
    final storage = ref.watch(offlineStorageProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    final centerCoord =
        _currentLocation?.toLatLng() ?? const LatLng(23.8103, 90.4125);

    // Dynamic greeting based on time of day
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Header with App Branding and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppConstants.appName,
                          style: AppTypography.displayMetric.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryNeon.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.primaryNeon.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            'v${AppConstants.appVersion}',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primaryNeon,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$greeting • ${AppConstants.appTagline}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.lightSurfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Text(
                    Formatters.formatDate(now),
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primaryNeon,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Active Journey Banner if tracking is currently in progress
            if (tracking.status.isRecording) ...[
              FuturisticCard(
                backgroundColor: AppColors.primaryNeon.withValues(alpha: 0.12),
                borderColor: AppColors.primaryNeon,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LiveJourneyScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.navigation_rounded,
                      color: AppColors.primaryNeon,
                      size: 28,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tracking ${tracking.mode.label} in Progress',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.primaryNeon,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${Formatters.formatDistance(tracking.distanceMeters)} • ${Formatters.formatDuration(tracking.activeDurationSeconds)} active',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.primaryNeon,
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],

            // Dominant Map & Mobility Dashboard Card
            FuturisticCard(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Map preview window
                    SizedBox(
                      height: 180,
                      child: Stack(
                        children: [
                          FlutterMap(
                            options: MapOptions(
                              initialCenter: centerCoord,
                              initialZoom: 14.5,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: AppConstants.osmTileUrl,
                                userAgentPackageName:
                                    AppConstants.appPackageName,
                                tileProvider: JourniqTileProvider(
                                  storage: storage,
                                  mode: mapMode,
                                  baseStoragePath: storage.cachedBasePath,
                                ),
                              ),
                              CircleLayer(
                                circles:
                                    CurrentLocationMarker.buildAccuracyCircle(
                                      _currentLocation,
                                    ),
                              ),
                              MarkerLayer(
                                markers: [
                                  CurrentLocationMarker.buildMarker(
                                    _currentLocation,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Floating Weather HUD overlay on top right of map
                          if (_homeWeather != null)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 220,
                                ),
                                child: FloatingWeatherCard(
                                  weather: _homeWeather,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Mode Selection and Start Controls
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SELECT TRANSPORT MODE',
                            style: AppTypography.labelSmall.copyWith(
                              letterSpacing: 1.0,
                              color: AppColors.textSecondaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Mode selection chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: JourneyMode.values.map((mode) {
                                final isSelected = mode == _selectedMode;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: InkWell(
                                    onTap: () =>
                                        setState(() => _selectedMode = mode),
                                    borderRadius: BorderRadius.circular(12),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryNeon.withValues(
                                                alpha: 0.16,
                                              )
                                            : (isDark
                                                ? AppColors.darkSurfaceElevated
                                                : AppColors.lightSurfaceElevated),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primaryNeon
                                              : (isDark
                                                  ? AppColors.darkBorder
                                                  : AppColors.lightBorder),
                                          width: isSelected ? 1.2 : 0.8,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            mode.icon,
                                            size: 16,
                                            color: isSelected
                                                ? AppColors.primaryNeon
                                                : (isDark
                                                    ? AppColors.textSecondaryDark
                                                    : AppColors.textSecondaryLight),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            mode.label,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? AppColors.primaryNeon
                                                  : (isDark
                                                      ? AppColors.textSecondaryDark
                                                      : AppColors.textSecondaryLight),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Start Journey Primary Action
                          FilledButton.icon(
                            onPressed: () => _startTracking(_selectedMode),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryNeon,
                              foregroundColor: Colors.black,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(
                              Icons.navigation_rounded,
                              size: 20,
                            ),
                            label: Text(
                              'Start ${_selectedMode.label} Journey',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // "This Month" Highlights (Strict Year + Month)
            statsAsync.maybeWhen(
              data: (stats) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This Month',
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FuturisticCard(
                            child: _monthlyStat(
                              Formatters.formatDistance(
                                stats.monthDistanceMeters,
                              ),
                              'Distance',
                              highlight: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FuturisticCard(
                            child: _monthlyStat(
                              '${stats.monthJourneys}',
                              'Journeys',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // Recent Journeys Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Journeys',
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextButton(
                  onPressed: widget.onNavigateToHistory,
                  child: const Text(
                    'See All',
                    style: TextStyle(color: AppColors.primaryNeon),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Recent Journeys List (Take top 3)
            journeysAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primaryNeon),
              ),
              error: (err, _) => const SizedBox.shrink(),
              data: (journeys) {
                if (journeys.isEmpty) {
                  return FuturisticCard(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        'No journeys yet. Start your first journey today!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: journeys.take(3).map((j) {
                    final mode = JourneyModeX.fromIndex(j.mode);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: FuturisticCard(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  JourneyDetailScreen(journeyId: j.id),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isDark
                                  ? AppColors.darkSurfaceElevated
                                  : AppColors.lightSurfaceElevated,
                              child: Icon(
                                mode.icon,
                                color: AppColors.primaryNeon,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mode.label,
                                    style: AppTypography.titleMedium,
                                  ),
                                  Text(
                                    '${Formatters.formatDistance(j.distanceMeters)} • ${Formatters.formatDuration(j.activeDurationSeconds)}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              Formatters.formatDate(j.startTime),
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark
                                    ? AppColors.textMutedDark
                                    : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthlyStat(String value, String label, {bool highlight = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTypography.largeMetric.copyWith(
            fontWeight: FontWeight.w800,
            color: highlight
                ? AppColors.primaryNeon
                : (isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}
