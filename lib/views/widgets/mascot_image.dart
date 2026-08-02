import 'package:flutter/material.dart';
import 'package:planit/core/theme/app_colors.dart';

/// Shows a cute mascot illustration from assets, gracefully falling back to an
/// icon when the image file is missing.
class MascotImage extends StatelessWidget {
  final String asset;
  final IconData fallback;
  final double size;

  const MascotImage({
    super.key,
    required this.asset,
    required this.fallback,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(fallback, size: size * 0.8, color: AppColors.ink),
    );
  }
}
