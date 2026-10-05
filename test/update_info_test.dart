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
}
