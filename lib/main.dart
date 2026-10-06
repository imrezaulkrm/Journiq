import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/shell_screen.dart';
import 'features/update/data/app_update_service.dart';
import 'features/update/domain/update_info.dart';
import 'features/update/presentation/update_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set immersive navigation and status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: JourniqApp()));
}

class JourniqApp extends ConsumerWidget {
  const JourniqApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journiq',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,
      home: const UpdateGate(child: ShellScreen()),
    );
  }
}

class UpdateGate extends StatefulWidget {
  final Widget child;
  const UpdateGate({super.key, required this.child});

  @override
  State<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends State<UpdateGate> with WidgetsBindingObserver {
  static final _service = AppUpdateService(
    currentVersion: AppConstants.appVersion,
    configurationUri: Uri.parse(AppConstants.defaultUpdateUrl),
  );

  UpdateInfo? _info;
  bool _optionalShown = false;
  DateTime? _lastCheck;

  @override
  void initState() {
    super.initState();
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
            DateTime.now().difference(_lastCheck!) > const Duration(hours: 6))) {
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
        final requirement = info.requirementFor(AppConstants.appVersion);
        if (requirement == UpdateRequirement.optional && !_optionalShown) {
          final isDismissed = await _service.isVersionDismissed(info.latestVersion);
          if (!isDismissed && mounted) {
            _optionalShown = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                UpdateDialog.show(
                  context,
                  info: info,
                  currentVersion: AppConstants.appVersion,
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
      // Fail silently without disrupting normal user flow
    }
  }

  @override
  Widget build(BuildContext context) {
    final requirement =
        _info?.requirementFor(AppConstants.appVersion) ??
        UpdateRequirement.none;

    if (requirement == UpdateRequirement.mandatory && _info != null) {
      return MandatoryUpdateView(info: _info!);
    }

    return widget.child;
  }
}
