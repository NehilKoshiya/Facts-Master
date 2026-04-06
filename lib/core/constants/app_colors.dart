import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF8B7CFF);
  static const secondary = Color(0xFF2DD4BF);
  static const accent = Color(0xFFFF9B6A);
  static const transparent = Colors.transparent;

  static const bgColor = Color(0xFF090B12);
  static const itemBgColor = Color(0xFF121723);
  static const secondItemBgColor = Color(0xFF171D2C);
  static const iconBgColor = Color(0xFF1A2233);
  static const iconColor = Color(0xFFF5F7FF);
  static const fevIconBgColor = Color(0xFF241824);
  static const categoryBgColor = Color(0xFF131928);

  static const darkPrimaryBg = Color(0xFF080A11);
  static const darkSoftBg = Color(0xFF0F1420);
  static const darkSurface = Color(0xFF141B29);
  static const darkSurfaceStrong = Color(0xFF1B2334);
  static const darkBorder = Color(0xFF252E43);
  static const darkTextPrimary = Color(0xFFF7F8FC);
  static const darkTextSecondary = Color(0xFF98A3BE);

  static const lightPrimaryBg = Color(0xFFF4F7FB);
  static const lightSoftBg = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFE9EEF7);
  static const lightBorder = Color(0x14091A33);
  static const lightTextPrimary = Color(0xFF10213B);
  static const lightTextSecondary = Color(0xFF5A6782);

  static const success = Color(0xFF2DCB8C);
  static const warning = Color(0xFFFFB54A);
  static const danger = Color(0xFFFF647C);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, Color(0xFFFFD166)],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF080A11), Color(0xFF0B101A), Color(0xFF121826)],
  );
}
