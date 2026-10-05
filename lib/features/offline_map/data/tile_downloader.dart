import 'dart:async';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/district_data.dart';
import '../domain/models/district_model.dart';
import 'offline_tile_storage.dart';

class TileCoord {
  final int z;
  final int x;
  final int y;

  const TileCoord(this.z, this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TileCoord &&
          runtimeType == other.runtimeType &&
          z == other.z &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => z.hashCode ^ x.hashCode ^ y.hashCode;
}

class TileDownloader {
  static const int maximumTilesPerPack = 5000;
  final OfflineTileStorage _storage;
  final http.Client _client;
  bool _isCancelled = false;
  bool _isPaused = false;

  TileDownloader(this._storage, [http.Client? client])
    : _client = client ?? http.Client();

  void cancel() {
    _isCancelled = true;
  }

  void pause() {
    _isPaused = true;
  }

  void resume() {
    _isPaused = false;
  }

  /// Calculates list of tile coordinates needed for a given bounding box & zoom levels
  static List<TileCoord> calculateTiles(
    DistrictDefinition district, {
    int? minZoom,
    int? maxZoom,
  }) {
    final startZoom = minZoom ?? district.minZoom;
    final endZoom = maxZoom ?? district.maxZoom;
    final tiles = <TileCoord>[];

    for (var z = startZoom; z <= endZoom; z++) {
      final n = math.pow(2.0, z).toDouble();

      final minX = ((district.minLng + 180.0) / 360.0 * n).floor();
      final maxX = ((district.maxLng + 180.0) / 360.0 * n).floor();

      // Latitude to Y: note maxLat corresponds to minY
      final minY = _latToY(district.maxLat, n);
      final maxY = _latToY(district.minLat, n);

      for (var x = minX; x <= maxX; x++) {
        for (var y = minY; y <= maxY; y++) {
          tiles.add(TileCoord(z, x, y));
        }
      }
    }

    return tiles;
  }

  static int _latToY(double lat, double n) {
    final latRad = lat * math.pi / 180.0;
    final val =
        (1.0 -
            (math.log(math.tan(latRad) + (1.0 / math.cos(latRad))) / math.pi)) /
        2.0 *
        n;
    return val.floor();
  }

  /// Downloads all tiles for a district while updating progress callback
  Stream<DistrictMapStatus> downloadDistrict(
    DistrictDefinition district,
  ) async* {
    _isCancelled = false;
    _isPaused = false;

    final tiles = calculateTiles(district);
    if (tiles.length > maximumTilesPerPack) {
      yield DistrictMapStatus(
        districtId: district.id,
        districtName: district.name,
        status: DownloadStatus.idle,
        totalTiles: tiles.length,
        downloadedTiles: 0,
      );
      return;
    }
    final total = tiles.length;
    var downloaded = 0;

    yield DistrictMapStatus(
      districtId: district.id,
      districtName: district.name,
      status: DownloadStatus.downloading,
      totalTiles: total,
      downloadedTiles: 0,
      sizeMb: (total * 20) / 1024.0, // estimated 20KB per tile
    );

    for (final tile in tiles) {
      if (_isCancelled) {
        yield DistrictMapStatus(
          districtId: district.id,
          districtName: district.name,
          status: DownloadStatus.idle,
          totalTiles: total,
          downloadedTiles: downloaded,
        );
        return;
      }

      while (_isPaused) {
        yield DistrictMapStatus(
          districtId: district.id,
          districtName: district.name,
          status: DownloadStatus.paused,
          totalTiles: total,
          downloadedTiles: downloaded,
        );
        await Future.delayed(const Duration(milliseconds: 500));
        if (_isCancelled) return;
      }

      // Check if tile already exists
      final exists = await _storage.hasTile(tile.z, tile.x, tile.y);
      if (!exists) {
        try {
          final url = Uri.parse(
            'https://tile.openstreetmap.org/${tile.z}/${tile.x}/${tile.y}.png',
          );
          final res = await _client
              .get(url, headers: {'User-Agent': AppConstants.userAgent})
              .timeout(const Duration(seconds: 8));

          if (res.statusCode == 200) {
            await _storage.saveTile(tile.z, tile.x, tile.y, res.bodyBytes);
          }
          // Slight throttle to be polite to tile servers
          await Future.delayed(const Duration(milliseconds: 30));
        } catch (_) {}
      }

      downloaded++;
      // Yield progress every 5 tiles or when complete
      if (downloaded % 5 == 0 || downloaded == total) {
        yield DistrictMapStatus(
          districtId: district.id,
          districtName: district.name,
          status: downloaded == total
              ? DownloadStatus.completed
              : DownloadStatus.downloading,
          totalTiles: total,
          downloadedTiles: downloaded,
        );
      }
    }

    final finalSize = await _storage.getStorageSizeMb();
    yield DistrictMapStatus(
      districtId: district.id,
      districtName: district.name,
      status: DownloadStatus.completed,
      totalTiles: total,
      downloadedTiles: total,
      sizeMb: finalSize,
    );
  }
}
