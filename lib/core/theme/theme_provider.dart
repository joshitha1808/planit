import 'package:flutter/material.dart';
import 'package:planit/core/theme/app_colors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeData build() {
    return _lightTheme;
  }
}

ThemeData _buildTheme() {
  const background = AppColors.backgroundLight;
  const surface = AppColors.surfaceLight;
  const onSurface = AppColors.ink;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: surface,
    onSurface: onSurface,
    onPrimary: AppColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: onSurface),
      titleTextStyle: TextStyle(
        color: onSurface,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    ),
    textTheme: Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(bodyColor: onSurface, displayColor: onSurface)
        .copyWith(
          titleMedium: const TextStyle(
            color: onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
  );
}

final _lightTheme = _buildTheme();
