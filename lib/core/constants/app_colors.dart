import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color darkPrimary = Color(0xFF121212);
  static const Color darkNavy = Color(0xFF1C1C1E);
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkCard = Color(0xFF161616);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA0A0A0);
  static const Color darkBorder = Color(0xFF262626);

  static const List<Color> darkGradient = [
    Color(0xFF0A0A0A),
    Color(0xFF121212),
    Color(0xFF1C1C1E),
  ];

  static const Color lightPrimary = Color(0xFF000000);
  static const Color lightBackground = Color(0xFFF9F9F9);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF121212);
  static const Color lightTextSecondary = Color(0xFF737373);
  static const Color lightBorder = Color(0xFFE5E5E5);

  static const List<Color> lightGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF5F5F5),
    Color(0xFFE5E5E5),
  ];

  static const Color greyBlue = Color(0xFF737373);
  static const Color actionBlue = Color(0xFFE31B23); // Repurposed to Brand Red
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningOrange = Color(0xFFEF6C00);
  static const Color white = Color(0xFFFFFFFF);

  static const Color primaryBlue = Color(0xFF121212);
  static const Color lightText = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9F9F9);

  static const Gradient accentGradient = LinearGradient(
    colors: [
      Color(0xFFE31B23), // Brand Red
      Color(0xFF000000), // Black
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
