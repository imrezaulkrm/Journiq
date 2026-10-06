import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import 'history/presentation/history_screen.dart';
import 'home/presentation/home_screen.dart';
import 'journey/domain/models/journey_mode.dart';
import 'journey/domain/models/tracking_state.dart';
import 'journey/presentation/screens/live_journey_screen.dart';
import 'journey/presentation/screens/mode_selection_sheet.dart';
import 'journey/providers/tracking_provider.dart';
import 'map/presentation/my_journey_map_screen.dart';
import 'settings/presentation/settings_screen.dart';
import 'statistics/presentation/statistics_screen.dart';

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  int _currentIndex = 0;
  bool _recoveryChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForActiveRecovery();
    });
  }

  Future<void> _checkForActiveRecovery() async {
    if (_recoveryChecked) return;
    _recoveryChecked = true;

    final active = await ref
        .read(trackingProvider.notifier)
        .checkActiveRecovery();
    if (active != null && mounted) {
      final mode = JourneyModeX.fromIndex(active.mode);
      final isDark = Theme.of(context).brightness == Brightness.dark;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.primaryNeon, width: 1.5),
          ),
          title: const Row(
            children: [
              Icon(Icons.restore_rounded, color: AppColors.primaryNeon),
              SizedBox(width: 10),
              Text('Journey in Progress'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'An unfinished ${mode.label} journey was detected from a previous session.',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Recorded distance: ${Formatters.formatDistance(active.distanceMeters)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                'Active duration: ${Formatters.formatDuration(active.activeDurationSeconds)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await ref
                    .read(trackingProvider.notifier)
                    .discardActiveJourney(active.id);
              },
              child: const Text(
                'Discard',
                style: TextStyle(color: AppColors.statusRed),
              ),
            ),
            FilledButton.tonal(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await ref.read(trackingProvider.notifier).stopAndSaveJourney();
              },
              child: const Text('End & Save'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LiveJourneyScreen()),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: Colors.black,
              ),
              child: const Text('Resume Tracking'),
            ),
          ],
        ),
      );
    }
  }

  void _onTabSelected(int index) {
    if (index == 1) {
      // Journey Tab: If tracking is active, navigate to live map, else show mode selector
      final tracking = ref.read(trackingProvider);
      if (tracking.status.isRecording) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const LiveJourneyScreen()));
      } else {
        _launchModePicker();
      }
      return;
    }
    setState(() => _currentIndex = index);
  }

  Future<void> _launchModePicker() async {
    final mode = await ModeSelectionSheet.show(context);
    if (mode != null && mounted) {
      final started = await ref
          .read(trackingProvider.notifier)
          .startJourney(mode);
      if (started && mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const LiveJourneyScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracking = ref.watch(trackingProvider);

    final screens = [
      HomeScreen(onNavigateToHistory: () => setState(() => _currentIndex = 4)),
      const SizedBox.shrink(), // Placeholder for Journey tab
      const MyJourneyMapScreen(),
      const StatisticsScreen(),
      const HistoryScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'Journiq'
              : _currentIndex == 2
              ? 'My Journey Map'
              : _currentIndex == 3
              ? 'Statistics'
              : 'History',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: tracking.status.isRecording,
              backgroundColor: AppColors.primaryNeon,
              smallSize: 8,
              child: const Icon(Icons.navigation_outlined),
            ),
            selectedIcon: const Icon(Icons.navigation_rounded),
            label: tracking.status.isRecording ? 'Tracking' : 'Start',
          ),
          const NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'My Map',
          ),
          const NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Stats',
          ),
          const NavigationDestination(
            icon: Icon(Icons.history_rounded),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
