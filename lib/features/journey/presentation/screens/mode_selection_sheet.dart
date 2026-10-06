import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/models/journey_mode.dart';

class ModeSelectionSheet extends StatefulWidget {
  final JourneyMode initialMode;
  final ValueChanged<JourneyMode> onSelected;

  const ModeSelectionSheet({
    super.key,
    this.initialMode = JourneyMode.walking,
    required this.onSelected,
  });

  static Future<JourneyMode?> show(
    BuildContext context, {
    JourneyMode initialMode = JourneyMode.walking,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet<JourneyMode>(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ModeSelectionSheet(
        initialMode: initialMode,
        onSelected: (mode) => Navigator.of(context).pop(mode),
      ),
    );
  }

  @override
  State<ModeSelectionSheet> createState() => _ModeSelectionSheetState();
}

class _ModeSelectionSheetState extends State<ModeSelectionSheet> {
  late JourneyMode _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialMode;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose Transport Mode',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select how you are travelling to optimize tracking speed filters.',
              style: AppTypography.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: JourneyMode.values.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.05,
              ),
              itemBuilder: (context, index) {
                final mode = JourneyMode.values[index];
                final isSelected = mode == _selected;

                return InkWell(
                  onTap: () => setState(() => _selected = mode),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryNeon.withValues(alpha: 0.15)
                          : (isDark
                              ? AppColors.darkSurfaceElevated
                              : AppColors.lightSurfaceElevated),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryNeon
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        width: isSelected ? 1.8 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          mode.icon,
                          size: 30,
                          color: isSelected
                              ? AppColors.primaryNeon
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mode.label,
                          style: AppTypography.labelSmall.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primaryNeon
                                : (isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => widget.onSelected(_selected),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryNeon,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.navigation_rounded),
              label: Text(
                'Start Tracking ${_selected.label}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
