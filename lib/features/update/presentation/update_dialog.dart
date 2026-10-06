import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/futuristic_card.dart';
import '../data/app_update_service.dart';
import '../domain/update_info.dart';

/// Futuristic update dialog matching Journiq's cyber neon aesthetic.
class UpdateDialog extends StatefulWidget {
  final UpdateInfo info;
  final String currentVersion;
  final VoidCallback? onDismiss;
  final ValueChanged<bool>? onSkipVersionChanged;

  const UpdateDialog({
    super.key,
    required this.info,
    required this.currentVersion,
    this.onDismiss,
    this.onSkipVersionChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required UpdateInfo info,
    required String currentVersion,
    VoidCallback? onDismiss,
    ValueChanged<bool>? onSkipVersionChanged,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => UpdateDialog(
        info: info,
        currentVersion: currentVersion,
        onDismiss: onDismiss,
        onSkipVersionChanged: onSkipVersionChanged,
      ),
    );
  }

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _skipThisVersion = false;
  bool _isLaunching = false;

  Future<void> _handleUpdate(String url) async {
    setState(() => _isLaunching = true);
    final success = await AppUpdateService.launchUpdateUrl(url);
    if (mounted) {
      setState(() => _isLaunching = false);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.statusRed,
            content: Text(
              'Could not open update link: $url',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final info = widget.info;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: FuturisticCard(
        enableGlass: true,
        padding: const EdgeInsets.all(22),
        borderColor: AppColors.primaryNeon.withValues(alpha: 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNeon.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryNeon,
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.system_update_rounded,
                    color: AppColors.primaryNeon,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Update Available',
                        style: AppTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceElevated
                                  : AppColors.lightSurfaceElevated,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                            child: Text(
                              'v${widget.currentVersion}',
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 14,
                              color: AppColors.primaryNeon,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryNeon.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: AppColors.primaryNeon,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'v${info.latestVersion}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.primaryNeon,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Release Notes Section
            if (info.releaseNotes.isNotEmpty) ...[
              Text(
                "WHAT'S NEW",
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 180),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceElevated.withValues(alpha: 0.6)
                      : AppColors.lightSurfaceElevated.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: info.releaseNotes.map((note) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4, right: 8),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                size: 13,
                                color: AppColors.primaryNeon,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                note,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Skip version checkbox
            InkWell(
              onTap: () {
                setState(() => _skipThisVersion = !_skipThisVersion);
                widget.onSkipVersionChanged?.call(_skipThisVersion);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _skipThisVersion,
                        activeColor: AppColors.primaryNeon,
                        checkColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (val) {
                          setState(() => _skipThisVersion = val ?? false);
                          widget.onSkipVersionChanged?.call(_skipThisVersion);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Don’t remind me again for this version',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onDismiss?.call();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Later',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _isLaunching
                        ? null
                        : () => _handleUpdate(info.updateUrl),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryNeon,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _isLaunching
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Icon(Icons.download_rounded, size: 18),
                    label: Text(
                      info.downloadUrl != null && info.downloadUrl!.endsWith('.apk')
                          ? 'Download APK'
                          : 'Update Now',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
            if (info.releaseUrl != null &&
                info.releaseUrl!.isNotEmpty &&
                info.releaseUrl != info.updateUrl) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: () => _handleUpdate(info.releaseUrl!),
                  icon: const Icon(Icons.open_in_new_rounded, size: 14),
                  label: const Text('View Release Notes on GitHub'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryTeal,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Cyber-styled mandatory update screen.
class MandatoryUpdateView extends StatelessWidget {
  final UpdateInfo info;

  const MandatoryUpdateView({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.statusRed.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.statusRed, width: 2),
                  ),
                  child: const Icon(
                    Icons.system_security_update_warning_rounded,
                    size: 56,
                    color: AppColors.statusRed,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Update Required',
                  style: AppTypography.displayMetric.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your current version of ${info.appName} is no longer supported.\nPlease update to version ${info.latestVersion} or higher to continue using Journiq.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
                if (info.releaseNotes.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  FuturisticCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HIGHLIGHTS IN v${info.latestVersion}:',
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryNeon,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...info.releaseNotes.map(
                          (note) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 14,
                                  color: AppColors.primaryNeon,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    note,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => AppUpdateService.launchUpdateUrl(info.updateUrl),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryNeon,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.download_rounded),
                  label: Text(
                    'Update to v${info.latestVersion}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
