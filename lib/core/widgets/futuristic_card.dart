import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Modern iPhone/iOS-style floating rounded card.
/// Provides a restrained translucent surface, subtle backdrop blur,
/// thin border, and soft depth without heavy or dated glassmorphism.
class FuturisticCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enableGlass;

  const FuturisticCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderColor,
    this.backgroundColor,
    this.borderRadius = 18,
    this.onTap,
    this.enableGlass = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final glassBg = isDark
        ? const Color(0xCC161B22) // Translucent dark surface
        : const Color(0xE6FFFFFF); // Translucent clean white surface

    final defaultBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final glassBorder = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.08);

    final effectiveBg = backgroundColor ?? (enableGlass ? glassBg : defaultBg);
    final effectiveBorder =
        borderColor ?? (enableGlass ? glassBorder : defaultBorder);

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (enableGlass) {
      content = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: content,
        ),
      );
    }

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: content,
      );
    }

    return content;
  }
}
