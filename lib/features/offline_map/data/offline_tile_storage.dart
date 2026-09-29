import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class OfflineTileStorage {
  Directory? _baseDir;

  /// Synchronous path for map tile providers after storage has been initialized.
  String? get cachedBasePath => _baseDir?.path;

  Future<Directory> get baseDirectory async {
    if (_baseDir != null) return _baseDir!;
    final appDocDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(appDocDir.path, 'journiq_offline_tiles'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _baseDir = dir;
    return dir;
  }

  Future<File> getTileFile(int z, int x, int y) async {
    final base = await baseDirectory;
    final filePath = p.join(base.path, '$z', '$x', '$y.png');
    return File(filePath);
  }

  Future<bool> hasTile(int z, int x, int y) async {
    final file = await getTileFile(z, x, y);
    return file.exists();
  }

  Future<void> saveTile(int z, int x, int y, List<int> bytes) async {
    final file = await getTileFile(z, x, y);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<double> getStorageSizeMb() async {
    final base = await baseDirectory;
    if (!await base.exists()) return 0.0;

    var totalBytes = 0;
    try {
      await for (final entity in base.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalBytes += await entity.length();
        }
      }
    } catch (_) {}

    return totalBytes / (1024 * 1024);
  }

  Future<void> clearAllTiles() async {
    final base = await baseDirectory;
    if (await base.exists()) {
      await base.delete(recursive: true);
      _baseDir = null;
    }
  }
}
