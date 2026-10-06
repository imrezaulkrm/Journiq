import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../../offline_map/data/offline_tile_provider.dart';
import '../../offline_map/providers/offline_map_provider.dart';
import '../providers/cumulative_map_provider.dart';

class MyJourneyMapScreen extends ConsumerStatefulWidget {
  const MyJourneyMapScreen({super.key});

  @override
  ConsumerState<MyJourneyMapScreen> createState() => _MyJourneyMapScreenState();
}

class _MyJourneyMapScreenState extends ConsumerState<MyJourneyMapScreen> {
  late final MapController _mapController;

  final List<Color> _routeColors = const [
    AppColors.primaryNeon,
    AppColors.primaryTeal,
    Color(0xFFFF4081),
    Color(0xFF7C4DFF),
    Color(0xFFFFAB00),
    Color(0xFF00E676),
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mapDataAsync = ref.watch(cumulativeMapProvider);
    final storage = ref.watch(offlineStorageProvider);
    final mapMode = ref.watch(mapModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Journey Map')),
      body: mapDataAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryNeon),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (data) {
          if (data.totalRoutes == 0) {
            return const EmptyStateView(
              icon: Icons.map_rounded,
              title: 'Your journey map is waiting.',
              description:
                  'Complete journeys to build your personal cumulative map of everywhere you have travelled.',
            );
          }

          // Build polylines from simplified routes
          final polylines = <Polyline>[];
          final allCoords = <LatLng>[];

          for (var i = 0; i < data.routes.length; i++) {
            final route = data.routes[i];
            if (route.simplifiedPoints.isNotEmpty) {
              allCoords.addAll(route.simplifiedPoints);
              polylines.add(
                Polyline(
                  points: route.simplifiedPoints,
                  strokeWidth: 4.0,
                  color: _routeColors[i % _routeColors.length],
                ),
              );
            }
          }

          final initialCenter = allCoords.isNotEmpty
              ? allCoords.first
              : const LatLng(23.8103, 90.4125);

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: 13.0,
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
                  PolylineLayer(polylines: polylines),
                ],
              ),

              // Floating Lifetime Cumulative Summary HUD
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: FuturisticCard(
                  enableGlass: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${data.totalRoutes}',
                            style: AppTypography.displayMetric.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryNeon,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'SAVED ROUTES',
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                      Column(
                        children: [
                          Text(
                            Formatters.formatDistance(data.totalDistanceMeters),
                            style: AppTypography.displayMetric.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'TOTAL DISTANCE',
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
              ),

              // Recenter map button
              if (allCoords.isNotEmpty)
                Positioned(
                  right: 16,
                  bottom: 24,
                  child: FloatingActionButton.small(
                    heroTag: 'cumulative_map_recenter',
                    backgroundColor: isDark
                        ? AppColors.darkSurfaceElevated
                        : AppColors.lightSurface,
                    foregroundColor: AppColors.primaryNeon,
                    onPressed: () {
                      _mapController.move(initialCenter, 13.0);
                    },
                    child: const Icon(Icons.my_location_rounded),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
