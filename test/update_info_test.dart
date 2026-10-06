import 'package:flutter_test/flutter_test.dart';
import 'package:journiq/features/update/domain/update_info.dart';

void main() {
  test('compares semantic versions numerically', () {
    expect(VersionComparator.compare('1.0.9', '1.0.10'), lessThan(0));
    expect(VersionComparator.compare('1.1.0', '1.0.9'), greaterThan(0));
    expect(VersionComparator.compare('2.0.0', '1.9.9'), greaterThan(0));
  });
  test('detects optional and mandatory updates', () {
    const info = UpdateInfo(
      latestVersion: '1.1.0',
      minimumSupportedVersion: '1.0.5',
      updateUrl: 'https://example.invalid',
      releaseNotes: ['x'],
    );
    expect(info.requirementFor('1.1.0'), UpdateRequirement.none);
    expect(info.requirementFor('1.0.5'), UpdateRequirement.optional);
    expect(info.requirementFor('1.0.4'), UpdateRequirement.mandatory);
  });
  test('malformed versions fail safely to zero', () {
    expect(VersionComparator.compare('not-a-version', '0.0.1'), lessThan(0));
  });

  test('parses full GitHub release JSON payload properly', () {
    final json = {
      'appName': 'Journiq',
      'latestVersion': '1.0.1',
      'minimumSupportedVersion': '1.0.0',
      'updateUrl':
          'https://github.com/imrezaulkrm/Journiq/releases/download/v1.0.1/Journiq-v1.0.1.apk',
      'downloadUrl':
          'https://github.com/imrezaulkrm/Journiq/releases/download/v1.0.1/Journiq-v1.0.1.apk',
      'releaseUrl': 'https://github.com/imrezaulkrm/Journiq/releases/tag/v1.0.1',
      'releaseNotes': [
        'Improved update system',
        'Improved journey tracking experience',
        'Improved map experience',
      ],
    };

    final info = UpdateInfo.fromJson(json);
    expect(info.appName, 'Journiq');
    expect(info.latestVersion, '1.0.1');
    expect(info.minimumSupportedVersion, '1.0.0');
    expect(info.downloadUrl, contains('Journiq-v1.0.1.apk'));
    expect(info.releaseUrl, contains('tag/v1.0.1'));
    expect(info.releaseNotes.length, 3);
  });

  test('falls back to downloadUrl or releaseUrl when updateUrl is omitted', () {
    final json = {
      'latestVersion': '1.0.2',
      'minimumSupportedVersion': '1.0.0',
      'downloadUrl': 'https://example.com/download.apk',
      'releaseNotes': 'Single string note',
    };

    final info = UpdateInfo.fromJson(json);
    expect(info.updateUrl, 'https://example.com/download.apk');
    expect(info.releaseNotes, ['Single string note']);
  });
}
