import 'package:flutter/material.dart';
import 'package:planit/core/theme/app_colors.dart';

/// The Planit app icon in a neo-brutalist bordered box. The source PNG has a
/// large transparent margin, so the artwork is scaled up to fill the box
/// instead of sitting small in the centre.
class AppLogo extends StatelessWidget {
  final double size;
  final bool shadow;

  const AppLogo({super.key, required this.size, this.shadow = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(size * 0.24),
        border: AppStyles.border(),
        boxShadow: shadow
            ? AppStyles.shadow(offset: const Offset(5, 5))
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Transform.scale(
        scale: 2.1,
        child: Image.asset(
          "assets/icon/app_icon.png",
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.check_circle_rounded,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}
