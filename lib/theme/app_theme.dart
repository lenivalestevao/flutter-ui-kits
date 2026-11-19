import 'package:flutter/material.dart';

/// Current theme mode. Change it from anywhere, for example in a settings
/// screen: `themeMode.value = ThemeMode.dark;`
final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

/// Light and dark themes shared by every kit. Change [brand] to re-theme
/// the whole collection.
class AppTheme {
  AppTheme._();

  static const Color brand = Color(0xFF6C5CE7);
  static const Color accent = Color(0xFF00B894);

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: brand, brightness: brightness);
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark ? const Color(0xFF0F1020) : const Color(0xFFF7F7FB),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: scheme.onSurface,
      ),
    );
  }
}
