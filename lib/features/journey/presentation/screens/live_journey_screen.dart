import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../map/controllers/map_following_controller.dart';
import '../../../offline_map/data/offline_tile_provider.dart';
import '../../../offline_map/providers/offline_map_provider.dart';
import '../../../weather/domain/models/weather_snapshot.dart';
import '../../../weather/presentation/floating_weather_card.dart';
import '../../domain/models/tracking_state.dart';
import '../../providers/tracking_provider.dart';
import '../widgets/current_location_marker.dart';
import '../widgets/follow_me_button.dart';
import '../widgets/live_metrics_panel.dart';
import '../widgets/stop_confirmation_dialog.dart';
import 'journey_summary_screen.dart';

class LiveJourneyScreen extends ConsumerStatefulWidget {
  const LiveJourneyScreen({super.key});

  @override
  ConsumerState<LiveJourneyScreen> createState() => _LiveJourneyScreenState();
}

class _LiveJourneyScreenState extends ConsumerState<LiveJourneyScreen>
    with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final MapFollowingController _followingController;
  WeatherSnapshot? _liveWeather;
  bool _weatherFetched = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _followingController = MapFollowingController(
      mapController: _mapController,
      vsync: this,
    );

    _fetchInitialWeather();
  }

  Future<void> _fetchInitialWeather() async {
    final metrics = ref.read(trackingProvider);
    if (metrics.currentPoint != null && !_weatherFetched) {
      _weatherFetched = true;
      final weatherService = ref.read(weatherServiceProvider);
      final w = await weatherService.getWeather(
        metrics.currentPoint!.latitude,
        metrics.currentPoint!.longitude,
      );
      if (mounted) setState(() => _liveWeather = w);
    }
  }

  @override
  void dispose() {
    _followingController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _handleStop() async {
    final metrics = ref.read(trackingProvider);

    final shouldStop = await StopConfirmationDialog.show(
      context,
      distanceMeters: metrics.distanceMeters,
      activeDurationSeconds: metrics.activeDurationSeconds,
      averageSpeedKmh: metrics.averageSpeedKmh,
      maxSpeedKmh: metrics.maxSpeedKmh,
    );

    if (shouldStop == true && mounted) {
      // Show loading overlay while finalizing transaction
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryNeon),
        ),
      );

      final savedId = await ref
          .read(trackingProvider.notifier)
          .stopAndSaveJourney();

      if (mounted) {
        Navigator.of(context).pop(); // dismiss loading
        if (savedId != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => JourneySummaryScreen(journeyId: savedId),
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(trackingProvider);
    final mapMode = ref.watch(mapModeProvider);
    final storage = ref.watch(offlineStorageProvider);

    // Listen for new GPS points to follow camera
    ref.listen(trackingProvider, (prev, next) {
      if (next.currentPoint != null &&
          (prev?.currentPoint == null ||
              prev!.currentPoint!.latitude != next.currentPoint!.latitude ||
              prev.currentPoint!.longitude != next.currentPoint!.longitude)) {
        _followingController.onLocationUpdate(next.currentPoint!.toLatLng());

        if (!_weatherFetched) {
          _fetchInitialWeather();
        }
      }
    });

    final currentPt = metrics.currentPoint;
    final initialCenter =
        currentPt?.toLatLng() ?? const LatLng(23.8103, 90.4125);
    final routePoints = metrics.routeCoordinates;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // 1. The Dominant Live Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 16.0,
              minZoom: 4,
              maxZoom: 18,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
              onPositionChanged: (camera, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _followingController.onUserManualGesture();
                  });
                }
              },
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
              // Route Polyline
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: routePoints,
                    strokeWidth: 5.5,
                    color: AppColors.primaryNeon,
                    borderColor: const Color(0xFF003D4D),
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
              // Accuracy radius circle
              CircleLayer(
                circles: CurrentLocationMarker.buildAccuracyCircle(currentPt),
              ),
              // Current Location Marker with heading
              MarkerLayer(
                markers: [CurrentLocationMarker.buildMarker(currentPt)],
              ),
            ],
          ),

          // 2. Top Header Bar (HUD overlay)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (leaves tracking running in background)
                  CircleAvatar(
                    backgroundColor: AppColors.darkSurfaceGlass,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // Compact weather HUD stays in the top safe-area band.
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 260),
                          child: FloatingWeatherCard(weather: _liveWeather),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Floating Follow Me Button (Visible only when follow paused)
          if (!_followingController.isFollowing && currentPt != null)
            Positioned(
              right: 16,
              bottom: 220,
              child: FollowMeButton(
                onPressed: () {
                  setState(() {
                    _followingController.recenter(currentPt.toLatLng());
                  });
                },
              ),
            ),

          // 4. Bottom Live Metrics HUD Panel
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: LiveMetricsPanel(
                metrics: metrics,
                onPauseResume: () {
                  final notifier = ref.read(trackingProvider.notifier);
                  if (metrics.status.isPaused) {
                    notifier.resumeJourney();
                  } else {
                    notifier.pauseJourney();
                  }
                },
                onStop: _handleStop,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
