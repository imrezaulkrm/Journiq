import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/shell_screen.dart';
import 'features/update/data/app_update_service.dart';
import 'features/update/domain/update_info.dart';
import 'package:url_launcher/url_launcher.dart';

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
  // Configure this with the real company/Play Store JSON endpoint for release.
  static final _service = AppUpdateService(
    currentVersion: '1.0.0',
    configurationUri: Uri.parse(
      'https://imrezaulkrm.github.io/journiq/update.json',
    ),
  );
  UpdateInfo? _info;
  bool _checking = true;
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
            DateTime.now().difference(_lastCheck!) >
                const Duration(hours: 6))) {
      _check();
    }
  }

  Future<void> _check() async {
    debugPrint('[Journiq UpdateGate] _check() started');
    debugPrint('[Journiq UpdateGate] service URI=${_service.configurationUri}');
    debugPrint(
      '[Journiq UpdateGate] current version=${_service.currentVersion}',
    );

    _lastCheck = DateTime.now();

    try {
      final info = await _service.check(force: true);

      debugPrint('[Journiq UpdateGate] check completed: $info');

      if (!mounted) return;

      setState(() {
        _info = info;
        _checking = false;
      });

      if (info != null) {
        debugPrint('[Journiq UpdateGate] latest=${info.latestVersion}');

        debugPrint(
          '[Journiq UpdateGate] minimum=${info.minimumSupportedVersion}',
        );

        debugPrint(
          '[Journiq UpdateGate] requirement='
          '${info.requirementFor(_service.currentVersion)}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[Journiq UpdateGate] ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking && _service.configurationUri != null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final requirement =
        _info?.requirementFor(_service.currentVersion) ??
        UpdateRequirement.none;
    if (requirement == UpdateRequirement.mandatory) {
      return _UpdateRequired(info: _info!);
    }
    if (requirement == UpdateRequirement.optional && !_optionalShown) {
      _optionalShown = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showOptional(context, _info!),
      );
    }
    return widget.child;
  }

  void _showOptional(BuildContext context, UpdateInfo info) {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New update available'),
        content: Text(
          'Version ${info.latestVersion}\n\n'
          '${info.releaseNotes.map((e) => '• $e').join('\n')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              launchUrl(
                Uri.parse(info.updateUrl),
                mode: LaunchMode.externalApplication,
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

class _UpdateRequired extends StatelessWidget {
  final UpdateInfo info;
  const _UpdateRequired({required this.info});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.system_update_rounded, size: 56),
            const SizedBox(height: 18),
            const Text(
              'Update Required',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'This version of Journiq is no longer supported.\nPlease update to continue.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => launchUrl(
                Uri.parse(info.updateUrl),
                mode: LaunchMode.externalApplication,
              ),
              child: const Text('Update Now'),
            ),
          ],
        ),
      ),
    ),
  );
}
