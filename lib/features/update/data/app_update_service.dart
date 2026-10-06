import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/update_info.dart';

class AppUpdateService {
  final String currentVersion;
  final Uri? configurationUri;
  final Duration cacheTtl;
  final http.Client _client;

  static const String _keyDismissedVersion = 'journiq_dismissed_update_version';

  AppUpdateService({
    required this.currentVersion,
    this.configurationUri,
    this.cacheTtl = const Duration(hours: 6),
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<UpdateInfo?> check({bool force = false}) async {
    if (configurationUri == null) return null;
    final prefs = await SharedPreferences.getInstance();
    final cached = _readCached(prefs);
    final checkedAt = prefs.getInt('journiq_update_checked_at') ?? 0;
    if (!force &&
        cached != null &&
        DateTime.now().millisecondsSinceEpoch - checkedAt <
            cacheTtl.inMilliseconds) {
      return cached;
    }
    try {
      final response = await _client
          .get(configurationUri!)
          .timeout(const Duration(seconds: 4));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return cached;
      }
      final info = UpdateInfo.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      if (info.latestVersion.isEmpty ||
          info.minimumSupportedVersion.isEmpty ||
          info.updateUrl.isEmpty) {
        return cached;
      }
      await prefs.setString('journiq_update_config', response.body);
      await prefs.setInt(
        'journiq_update_checked_at',
        DateTime.now().millisecondsSinceEpoch,
      );
      return info;
    } catch (_) {
      return cached;
    }
  }

  Future<void> dismissVersion(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDismissedVersion, version.trim());
  }

  Future<bool> isVersionDismissed(String version) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getString(_keyDismissedVersion)?.trim();
    return dismissed == version.trim();
  }

  Future<void> clearDismissedVersion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDismissedVersion);
  }

  static Future<bool> launchUpdateUrl(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return false;

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return true;
    } catch (_) {}

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );
      if (launched) return true;
    } catch (_) {}

    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } catch (_) {
      return false;
    }
  }

  UpdateInfo? _readCached(SharedPreferences prefs) {
    final raw = prefs.getString('journiq_update_config');
    if (raw == null) return null;
    try {
      return UpdateInfo.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
