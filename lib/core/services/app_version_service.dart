import 'package:package_info_plus/package_info_plus.dart';

class AppVersionService {
  static PackageInfo? _packageInfo;

  static Future<PackageInfo> get packageInfo async {
    return _packageInfo ??= await PackageInfo.fromPlatform();
  }

  static Future<String> get version async {
    final info = await packageInfo;
    return info.version;
  }

  static Future<String> get buildNumber async {
    final info = await packageInfo;
    return info.buildNumber;
  }

  static Future<String> get fullVersion async {
    final info = await packageInfo;
    return '${info.version}+${info.buildNumber}';
  }

  static Future<String> get userAgent async {
    final info = await packageInfo;
    return 'JourniqApp/${info.version} (contact: support@journiq.app)';
  }
}
