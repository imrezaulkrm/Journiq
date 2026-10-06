enum UpdateRequirement { none, optional, mandatory }

class UpdateInfo {
  final String appName;
  final String latestVersion;
  final String minimumSupportedVersion;
  final String updateUrl;
  final String? downloadUrl;
  final String? releaseUrl;
  final List<String> releaseNotes;

  const UpdateInfo({
    this.appName = 'Journiq',
    required this.latestVersion,
    required this.minimumSupportedVersion,
    required this.updateUrl,
    this.downloadUrl,
    this.releaseUrl,
    required this.releaseNotes,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    String value(String key) => (json[key] as String?)?.trim() ?? '';

    final rawNotes = json['releaseNotes'];

    final notes = rawNotes is List
        ? rawNotes
              .whereType<String>()
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
        : rawNotes is String
        ? [rawNotes.trim()]
        : <String>[];

    final rawUpdateUrl = value('updateUrl');
    final rawDownloadUrl = value('downloadUrl');
    final rawReleaseUrl = value('releaseUrl');

    final effectiveUpdateUrl = rawUpdateUrl.isNotEmpty
        ? rawUpdateUrl
        : (rawDownloadUrl.isNotEmpty ? rawDownloadUrl : rawReleaseUrl);

    return UpdateInfo(
      appName: value('appName').isNotEmpty ? value('appName') : 'Journiq',
      latestVersion: value('latestVersion'),
      minimumSupportedVersion: value('minimumSupportedVersion'),
      updateUrl: effectiveUpdateUrl,
      downloadUrl: rawDownloadUrl.isNotEmpty ? rawDownloadUrl : null,
      releaseUrl: rawReleaseUrl.isNotEmpty ? rawReleaseUrl : null,
      releaseNotes: notes,
    );
  }

  UpdateRequirement requirementFor(String installedVersion) {
    if (VersionComparator.compare(installedVersion, minimumSupportedVersion) <
        0) {
      return UpdateRequirement.mandatory;
    }

    if (VersionComparator.compare(installedVersion, latestVersion) < 0) {
      return UpdateRequirement.optional;
    }

    return UpdateRequirement.none;
  }
}

class VersionComparator {
  static int compare(String left, String right) {
    final a = _parts(left);
    final b = _parts(right);

    for (var i = 0; i < 3; i++) {
      final result = a[i].compareTo(b[i]);

      if (result != 0) {
        return result;
      }
    }

    return 0;
  }

  static List<int> _parts(String value) {
    final match = RegExp(
      r'^(?:v)?(\d+)(?:\.(\d+))?(?:\.(\d+))?',
    ).firstMatch(value.trim());

    if (match == null) {
      return [0, 0, 0];
    }

    return [
      for (var i = 1; i <= 3; i++) int.tryParse(match.group(i) ?? '') ?? 0,
    ];
  }
}
