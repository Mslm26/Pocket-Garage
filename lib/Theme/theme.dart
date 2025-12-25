import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF1C1C1E);
  static const Color cardBackground = Color(0xFF2C2C2C);
  static const Color accent = Color(0xFF39FF14);
  static const Color primaryText = Color(0xFFE0E0E0);
  static const Color secondaryText = Color(0xFF8E8E93);

  static const Color backgroundLight = Color(0xFFF2F2F7);
  static const Color cardBackgroundLight = Color(0xFFFFFFFF);
  static const Color primaryTextLight = Color(0xFF000000);
  static const Color secondaryTextLight = Color(0xFF3C3C43);
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.accent,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.background,
      surface: AppColors.cardBackground,
      onSurface: AppColors.primaryText,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.primaryText,
      titleTextStyle: const TextStyle(
        color: AppColors.accent,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      shape: Border(
        bottom: BorderSide(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.background,
      elevation: 0,
      shape: CircleBorder(),
      iconSize: 28.0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryText),
      bodyMedium: TextStyle(color: AppColors.secondaryText),
      titleLarge:
          TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.bold),
      titleMedium:
          TextStyle(color: AppColors.primaryText, fontWeight: FontWeight.w500),
    ),
  );
}

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    primaryColor: AppColors.accent,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      onPrimary: Colors.white,
      surface: AppColors.cardBackgroundLight,
      onSurface: AppColors.primaryTextLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.primaryTextLight,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackgroundLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
      iconSize: 28.0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryTextLight),
      bodyMedium: TextStyle(color: AppColors.secondaryTextLight),
      titleLarge: TextStyle(
          color: AppColors.primaryTextLight, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          color: AppColors.primaryTextLight, fontWeight: FontWeight.w500),
    ),
  );
}
