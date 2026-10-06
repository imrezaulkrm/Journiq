import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:journiq/core/theme/app_theme.dart';
import 'package:journiq/features/update/domain/update_info.dart';
import 'package:journiq/features/update/presentation/update_dialog.dart';
import 'package:journiq/main.dart';

void main() {
  testWidgets('Flutter test harness renders a Journiq surface', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Text('Journiq')));
    expect(find.text('Journiq'), findsOneWidget);
  });

  testWidgets('UpdateGate renders child immediately without blocking startup', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: UpdateGate(
          appVersion: '1.0.3',
          child: Scaffold(
            body: Text('Journiq Shell Content'),
          ),
        ),
      ),
    );

    // Initial frame must show the child immediately (non-blocking)
    expect(find.text('Journiq Shell Content'), findsOneWidget);
  });

  testWidgets('UpdateDialog renders versions, release notes and action buttons', (tester) async {
    const info = UpdateInfo(
      latestVersion: '1.0.2',
      minimumSupportedVersion: '1.0.0',
      updateUrl: 'https://example.com/update.apk',
      downloadUrl: 'https://example.com/update.apk',
      releaseNotes: ['Enhanced UI theme adaptivity', 'Improved update popup'],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                UpdateDialog.show(
                  ctx,
                  info: info,
                  currentVersion: '1.0.1',
                );
              },
              child: const Text('Show Dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    expect(find.text('New Update Available'), findsOneWidget);
    expect(find.text('v1.0.1'), findsOneWidget);
    expect(find.text('v1.0.2'), findsOneWidget);
    expect(find.text('Enhanced UI theme adaptivity'), findsOneWidget);
    expect(find.text('Improved update popup'), findsOneWidget);
    expect(find.text('Later'), findsOneWidget);
    expect(find.text('Download APK'), findsOneWidget);
  });

  testWidgets('MandatoryUpdateView renders requirement message and update action', (tester) async {
    const info = UpdateInfo(
      latestVersion: '2.0.0',
      minimumSupportedVersion: '2.0.0',
      updateUrl: 'https://example.com/update.apk',
      releaseNotes: ['Breaking changes require upgrade'],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const MandatoryUpdateView(info: info),
      ),
    );

    expect(find.text('Update Required'), findsOneWidget);
    expect(find.text('Update to v2.0.0'), findsOneWidget);
    expect(find.text('Breaking changes require upgrade'), findsOneWidget);
  });
}
