import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/modules/profile/profile_model.dart';
import 'package:rawnes/core/services/auth_service.dart';
import 'package:rawnes/core/services/storage_service.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final isDarkMode = false.obs;
  final rxUser = Rxn<UserModel>();
  final isProfileLoading = false.obs;

  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isProfileLoading.value = true;
    try {
      final response = await _authService.getProfile();

      if (response.containsKey('email')) {
        rxUser.value = UserModel.fromJson(response);
      } else {
        Get.snackbar('Error', 'Failed to load profile');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isProfileLoading.value = false;
    }
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }

  void toggleTheme() {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      isDarkMode.value = false;
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      isDarkMode.value = true;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      await StorageService.clearTokens();
    } catch (e) {
      await StorageService.clearTokens();
    } finally {
      rxUser.value = null;
      Get.offAllNamed('/login');
    }
  }
}