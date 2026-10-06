import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/services/app_version_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/shell_screen.dart';
import 'features/update/data/app_update_service.dart';
import 'features/update/domain/update_info.dart';
import 'features/update/presentation/update_dialog.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load installed app version from Android/iOS package metadata.
  final appVersion = await AppVersionService.version;

  // Set immersive navigation and status bar style.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(ProviderScope(child: JourniqApp(appVersion: appVersion)));
}

class JourniqApp extends ConsumerWidget {
  final String appVersion;

  const JourniqApp({super.key, required this.appVersion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journiq',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: UpdateGate(appVersion: appVersion, child: const ShellScreen()),
    );
  }
}

class UpdateGate extends StatefulWidget {
  final Widget child;
  final String appVersion;

  const UpdateGate({super.key, required this.child, required this.appVersion});

  @override
  State<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends State<UpdateGate> with WidgetsBindingObserver {
  late final AppUpdateService _service;

  UpdateInfo? _info;
  bool _optionalShown = false;
  DateTime? _lastCheck;

  @override
  void initState() {
    super.initState();

    _service = AppUpdateService(
      currentVersion: widget.appVersion,
      configurationUri: Uri.parse(AppConstants.defaultUpdateUrl),
    );

    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        (_lastCheck == null ||
            DateTime.now().difference(_lastCheck!) >
                const Duration(hours: 6))) {
      _check();
    }
  }

  Future<void> _check() async {
    _lastCheck = DateTime.now();

    try {
      final info = await _service.check(force: true);

      if (!mounted) return;

      setState(() {
        _info = info;
      });

      if (info != null) {
        final requirement = info.requirementFor(widget.appVersion);

        if (requirement == UpdateRequirement.optional && !_optionalShown) {
          final isDismissed = await _service.isVersionDismissed(
            info.latestVersion,
          );

          if (!isDismissed && mounted) {
            _optionalShown = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                UpdateDialog.show(
                  context,
                  info: info,
                  currentVersion: widget.appVersion,
                  onSkipVersionChanged: (skip) {
                    if (skip) {
                      _service.dismissVersion(info.latestVersion);
                    } else {
                      _service.clearDismissedVersion();
                    }
                  },
                );
              }
            });
          }
        }
      }
    } catch (_) {
      // Fail silently without disrupting normal user flow.
    }
  }

  @override
  Widget build(BuildContext context) {
    final requirement =
        _info?.requirementFor(widget.appVersion) ?? UpdateRequirement.none;

    if (requirement == UpdateRequirement.mandatory && _info != null) {
      return MandatoryUpdateView(info: _info!);
    }

    return widget.child;
  }
}
