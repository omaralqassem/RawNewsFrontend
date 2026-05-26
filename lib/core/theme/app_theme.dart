import 'package:flutter/material.dart';
import 'package:rawnes/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.actionBlue, // This is now the Brand Red
    scaffoldBackgroundColor: AppColors.darkBackground, // Deep black background
    fontFamily: 'Poppins',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.actionBlue,
      secondary: AppColors.actionBlue,
      surface: AppColors.darkCard,
      error: AppColors.errorRed,
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.darkTextPrimary),
      displayMedium: TextStyle(color: AppColors.darkTextPrimary),
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
      bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
      bodySmall: TextStyle(color: AppColors.darkTextSecondary),
      labelLarge: TextStyle(color: AppColors.darkTextPrimary),
    ),

    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return AppColors.greyBlue;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.actionBlue; // Red track when selected
        }
        return Colors.white10;
      }),
    ),

    dividerTheme: DividerThemeData(color: AppColors.darkBorder, thickness: 1),
  );

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.actionBlue,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: 'Poppins',

    colorScheme: const ColorScheme.light(
      primary: AppColors.actionBlue,
      secondary: AppColors.actionBlue,
      surface: AppColors.lightCard,
      error: AppColors.errorRed,
      onPrimary: Colors.white,
      onSurface: AppColors.lightTextPrimary,
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColors.lightTextPrimary),
      displayMedium: TextStyle(color: AppColors.lightTextPrimary),
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
      bodyMedium: TextStyle(color: AppColors.lightTextPrimary),
      bodySmall: TextStyle(color: AppColors.lightTextSecondary),
      labelLarge: TextStyle(color: AppColors.lightTextPrimary),
    ),

    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.actionBlue;
        }
        return Colors.grey.shade300;
      }),
    ),

    dividerTheme: DividerThemeData(color: AppColors.lightBorder, thickness: 1),
  );
}
