import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class FollowMeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FollowMeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.darkSurfaceElevated,
        foregroundColor: AppColors.primaryNeon,
        elevation: 6,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.primaryNeon, width: 1.5),
        ),
      ),
      icon: const Icon(Icons.my_location_rounded, size: 18),
      label: Text(
        'Follow Me',
        style: AppTypography.titleMedium.copyWith(
          fontSize: 13,
          color: AppColors.primaryNeon,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
