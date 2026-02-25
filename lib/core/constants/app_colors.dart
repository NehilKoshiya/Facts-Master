import 'package:flutter/material.dart';

class AppColors {
  // 🔥 Neon Brand Colors
  static const neonPink = Color(0xFF6B78FF);
  static const electricPurple = Color(0xFF8A2BFF);
  static const hotPink = Color(0xFFFF66C4);
  static const deepMagenta = Color(0xFFCC0F69);
  static const transparent = Colors.transparent;
  static const itemBgColor = Color(0xFF0e0843);
  static const bgColor = Color(0xFF0D001C);
  static const secondItemBgColor = Color(0xFF252156);
  static const iconBgColor = Color(0xFF0d3151);
  static const iconColor = Color(0xFF1d56d2);
  static const fevIconBgColor = Color(0xFF330934);
  static const categoryBgColor = Color(0xFF1b0f3d);

  // 🌙 Dark Mode
  static const darkPrimaryBg = Color(0xFF0D0D0F);
  static const darkSoftBg = Color(0xFF14141A);
  static const neonGlowShadow = Color(0xFF1A0028);

  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFB8B8C7);

  // ☀️ Light Mode
  static const lightPrimaryBg = Color(0xFFFFFFFF);
  static const lightPinkTint = Color(0xFFFFF3F9);
  static const paleLavenderTint = Color(0xFFF7F0FF);

  static const lightTextPrimary = Color(0xFF1A1A1A);
  static const lightTextSecondary = Color(0xFF5A5A5A);

  // 🌈 Gradient
  static const LinearGradient neonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonPink, electricPurple],
  );
}
