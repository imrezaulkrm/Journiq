import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/district_data.dart';
import '../data/offline_tile_provider.dart';
import '../data/offline_tile_storage.dart';
import '../data/tile_downloader.dart';
import '../domain/models/district_model.dart';

final offlineStorageProvider = Provider<OfflineTileStorage>((ref) {
  return OfflineTileStorage();
});

final mapModeProvider = StateProvider<MapMode>((ref) {
  return MapMode.automatic;
});

class OfflineMapState {
  final Map<String, DistrictMapStatus> districtStatuses;
  final double totalStorageMb;
  final String? activeDownloadingDistrictId;

  const OfflineMapState({
    required this.districtStatuses,
    required this.totalStorageMb,
    this.activeDownloadingDistrictId,
  });

  OfflineMapState copyWith({
    Map<String, DistrictMapStatus>? districtStatuses,
    double? totalStorageMb,
    String? activeDownloadingDistrictId,
  }) {
    return OfflineMapState(
      districtStatuses: districtStatuses ?? this.districtStatuses,
      totalStorageMb: totalStorageMb ?? this.totalStorageMb,
      activeDownloadingDistrictId:
          activeDownloadingDistrictId ?? this.activeDownloadingDistrictId,
    );
  }
}

final offlineMapControllerProvider =
    StateNotifierProvider<OfflineMapController, OfflineMapState>((ref) {
  final storage = ref.watch(offlineStorageProvider);
  return OfflineMapController(storage);
});

class OfflineMapController extends StateNotifier<OfflineMapState> {
  final OfflineTileStorage _storage;
  TileDownloader? _activeDownloader;
  StreamSubscription<DistrictMapStatus>? _downloadSub;

  OfflineMapController(this._storage)
      : super(OfflineMapState(
          districtStatuses: {
            for (final d in DistrictData.districts)
              d.id: DistrictMapStatus(
                districtId: d.id,
                districtName: d.name,
              )
          },
          totalStorageMb: 0.0,
        )) {
    refreshStorage();
  }

  Future<void> refreshStorage() async {
    final size = await _storage.getStorageSizeMb();
    state = state.copyWith(totalStorageMb: size);
  }

  void startDownload(DistrictDefinition district) {
    if (state.activeDownloadingDistrictId != null) return;

    _activeDownloader = TileDownloader(_storage);
    state = state.copyWith(activeDownloadingDistrictId: district.id);

    _downloadSub = _activeDownloader!.downloadDistrict(district).listen(
      (status) {
        final updatedMap = Map<String, DistrictMapStatus>.of(state.districtStatuses);
        updatedMap[district.id] = status;

        state = state.copyWith(
          districtStatuses: updatedMap,
          activeDownloadingDistrictId: status.status == DownloadStatus.downloading ||
                  status.status == DownloadStatus.paused
              ? district.id
              : null,
        );

        if (status.status == DownloadStatus.completed) {
          refreshStorage();
        }
      },
      onError: (err) {
        state = state.copyWith(activeDownloadingDistrictId: null);
      },
      onDone: () {
        if (state.activeDownloadingDistrictId == district.id) {
          state = state.copyWith(activeDownloadingDistrictId: null);
        }
      },
    );
  }

  void cancelDownload(String districtId) {
    if (state.activeDownloadingDistrictId == districtId) {
      _activeDownloader?.cancel();
      _downloadSub?.cancel();
      state = state.copyWith(activeDownloadingDistrictId: null);
    }
  }

  Future<void> clearAllStorage() async {
    await _storage.clearAllTiles();
    await refreshStorage();
  }

  @override
  void dispose() {
    _downloadSub?.cancel();
    super.dispose();
  }
}
