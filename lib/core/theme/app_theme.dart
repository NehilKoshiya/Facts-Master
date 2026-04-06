import 'package:daily_facts/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const double screenPadding = 20;
  static const double sectionSpacing = 20;
  static const double cardRadius = 28;

  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.lightSoftBg,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
    );

    return _baseTheme(
      scheme: scheme,
      scaffold: AppColors.lightPrimaryBg,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      cardColor: AppColors.lightSoftBg,
      divider: AppColors.lightBorder,
      navBackground: Colors.white,
    );
  }

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.darkSoftBg,
      error: AppColors.danger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkTextPrimary,
    );

    return _baseTheme(
      scheme: scheme,
      scaffold: AppColors.darkPrimaryBg,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      cardColor: AppColors.darkSurface,
      divider: AppColors.darkBorder,
      navBackground: AppColors.darkSoftBg,
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme scheme,
    required Color scaffold,
    required Color textPrimary,
    required Color textSecondary,
    required Color cardColor,
    required Color divider,
    required Color navBackground,
  }) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      primaryColor: scheme.primary,
      hintColor: textSecondary,
      fontFamily: 'DM Sans',
      splashFactory: InkRipple.splashFactory,
      cardColor: cardColor,
      dividerColor: divider,
    );

    final textTheme = base.textTheme.copyWith(
      displaySmall: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 34,
        fontWeight: FontWeight.w800,
        height: 1.1,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.15,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: textPrimary,
        titleTextStyle: textTheme.titleMedium,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: navBackground,
        selectedItemColor: scheme.primary,
        unselectedItemColor: textSecondary,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: textSecondary,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium,
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: cardColor,
        side: BorderSide(color: divider),
        labelStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceStrong,
        hintStyle: textTheme.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceStrong,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.darkTextPrimary,
        ),
      ),
    );
  }
}
