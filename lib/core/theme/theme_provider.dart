import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeData build() {
    return _lightTheme;
  }

  void toggleTheme() {
    state = state.brightness == Brightness.light ? _darkTheme : _lightTheme;
  }
}

final _lightTheme = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: Colors.blue,
  useMaterial3: true,
);

final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: Colors.blue,
  useMaterial3: true,
);
