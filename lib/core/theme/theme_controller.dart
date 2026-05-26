import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/core/storage/local_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = true.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() {
    _isDarkMode.value = StorageService.getDarkMode();
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    await StorageService.setDarkMode(_isDarkMode.value);
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    await StorageService.setDarkMode(value);
  }

  Color get backgroundColor =>
      isDarkMode ? AppColors.darkBackground : AppColors.lightBackground;

  Color get cardColor => isDarkMode ? AppColors.darkCard : AppColors.lightCard;

  Color get textPrimary =>
      isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get textSecondary =>
      isDarkMode ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  Color get borderColor =>
      isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;

  List<Color> get gradientColors =>
      isDarkMode ? AppColors.darkGradient : AppColors.lightGradient;

  Color get iconBgColor => isDarkMode
      ? Colors.white.withOpacity(0.08)
      : AppColors.actionBlue.withOpacity(0.08);

  Color get glowBlue => isDarkMode
      ? AppColors.actionBlue.withOpacity(0.15)
      : AppColors.actionBlue.withOpacity(0.08);

  Color get glowPurple => isDarkMode
      ? Colors.white.withOpacity(0.03)
      : Colors.black.withOpacity(0.03);
}
