import 'package:flutter/material.dart';

abstract final class WellLessColors {
  static const background = Color(0xFF0A0A0A);
  static const canvas = Color(0xFF060606);
  static const surface = Color(0xFF111111);
  static const surfaceRaised = Color(0xFF141414);
  static const border = Color(0xFF232323);
  static const divider = Color(0xFF1C1C1C);
  static const primary = Color(0xFFFB311E);
  static const text = Color(0xFFECECEC);
  static const muted = Color(0xFF888888);
  static const dim = Color(0xFF555555);
  static const faint = Color(0xFF333333);
  static const success = Color(0xFF50DF8A);
  static const successSurface = Color(0xFF061B0B);
}

abstract final class WellLessTheme {
  static ThemeData get dark {
    const base = TextStyle(
      color: WellLessColors.text,
      fontFamily: 'sans-serif',
      height: 1.35,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: WellLessColors.background,
      colorScheme: const ColorScheme.dark(
        primary: WellLessColors.primary,
        surface: WellLessColors.surface,
        onSurface: WellLessColors.text,
      ),
      textTheme: const TextTheme(
        displayLarge: base,
        displayMedium: base,
        displaySmall: base,
        headlineLarge: base,
        headlineMedium: base,
        headlineSmall: base,
        titleLarge: base,
        titleMedium: base,
        titleSmall: base,
        bodyLarge: base,
        bodyMedium: base,
        bodySmall: base,
        labelLarge: base,
        labelMedium: base,
        labelSmall: base,
      ),
      dividerColor: WellLessColors.border,
      splashColor: WellLessColors.primary.withValues(alpha: 0.12),
      highlightColor: Colors.transparent,
      useMaterial3: true,
    );
  }
}

TextStyle condensed({
  double size = 14,
  FontWeight weight = FontWeight.w700,
  Color color = WellLessColors.text,
  double? letterSpacing,
  double? height,
}) => TextStyle(
  fontFamily: 'sans-serif-condensed',
  fontSize: size,
  fontWeight: weight,
  color: color,
  letterSpacing: letterSpacing,
  height: height,
);

TextStyle scoreNumber({
  double size = 40,
  Color color = WellLessColors.text,
  double? height,
}) => TextStyle(
  fontFamily: 'BarlowCondensed',
  fontSize: size,
  fontWeight: FontWeight.w900,
  color: color,
  height: height,
  letterSpacing: -1.2,
);
