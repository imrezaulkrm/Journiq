import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:path/path.dart' as p;
import '../../../../core/constants/app_constants.dart';
import 'offline_tile_storage.dart';

enum MapMode {
  automatic, // Prefer local offline tile, fallback to online
  onlineOnly, // Always fetch from online OSM
  offlineOnly, // Only use locally downloaded offline tiles
}

class JourniqTileProvider extends TileProvider {
  final OfflineTileStorage storage;
  final MapMode mode;
  final String? baseStoragePath;

  JourniqTileProvider({
    required this.storage,
    this.mode = MapMode.automatic,
    this.baseStoragePath,
  }) : super(headers: {'User-Agent': AppConstants.userAgent});

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    if (baseStoragePath != null && mode != MapMode.onlineOnly) {
      final tileFilePath = p.join(
        baseStoragePath!,
        '${coordinates.z}',
        '${coordinates.x}',
        '${coordinates.y}.png',
      );

      final localFile = File(tileFilePath);
      if (localFile.existsSync()) {
        return FileImage(localFile);
      }
    }

    if (mode == MapMode.offlineOnly) {
      // In offline-only mode, if tile not present, don't hit network
      // Return local placeholder or empty file
      if (baseStoragePath != null) {
        final localFile = File(
          p.join(
            baseStoragePath!,
            '${coordinates.z}',
            '${coordinates.x}',
            '${coordinates.y}.png',
          ),
        );
        return FileImage(localFile);
      }
    }

    // Default to network
    final url = getTileUrl(coordinates, options);
    return NetworkImage(url, headers: headers);
  }
}
