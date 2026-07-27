import 'package:flutter/material.dart';

/// Cute neo-brutalism palette + shared style tokens.
class AppColors {
  AppColors._();

  /// The bold outline / hard-shadow colour used everywhere.
  static const Color ink = Color(0xFF1D1B22);

  // Backgrounds
  static const Color backgroundLight = Color(0xFFFFF6E9); // warm cream
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Accents
  static const Color primary = Color(0xFFFF8A5B); // playful coral
  static const Color secondary = Color(0xFF7BD389); // fresh mint

  /// Soft pastel spread used for category cards / chips.
  static const List<Color> pastels = [
    Color(0xFFFFADAD), // pink
    Color(0xFFFFD6A5), // peach
    Color(0xFFFDE68A), // butter
    Color(0xFFB8F2C9), // mint
    Color(0xFF9BE7FF), // sky
    Color(0xFFA9C7FF), // blue
    Color(0xFFC9BCFF), // lavender
    Color(0xFFFFC6F5), // rose
  ];

  /// Deterministically map any label (e.g. a category) to a pastel colour so
  /// the same category always looks the same.
  static Color pastelFor(String seed) {
    if (seed.isEmpty) return pastels.first;
    final index = seed.codeUnits.fold<int>(0, (a, b) => a + b) % pastels.length;
    return pastels[index];
  }
}

/// Neo-brutalism geometry tokens.
class AppStyles {
  AppStyles._();

  static const double borderWidth = 2.6;
  static const double radius = 16;

  static Border border({Color? color}) =>
      Border.all(color: color ?? AppColors.ink, width: borderWidth);

  /// Hard, un-blurred offset shadow — the signature neo-brutalist look.
  static List<BoxShadow> shadow({
    Offset offset = const Offset(4, 4),
    Color? color,
  }) => [
    BoxShadow(
      color: color ?? AppColors.ink,
      offset: offset,
      blurRadius: 0,
      spreadRadius: 0,
    ),
  ];
}
