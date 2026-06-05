import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/modules/profile/profile_model.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final isDarkMode = false.obs;
  final rxUser = Rxn<UserModel>();
  final isProfileLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;

    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    isProfileLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      final mockJsonResponse = {
        "id": "usr_9920",
        "name": "Sarah Jenkins",
        "email": "s.jenkins@rawnews.com",
        "is_member": true,
        "avatar_url": null,
      };

      rxUser.value = UserModel.fromJson(mockJsonResponse);
    } catch (e) {
      Get.snackbar(
        "error_title".tr,
        "failed_to_load_profile".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
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
      // await _localStorage.clearToken();

      rxUser.value = null;
      Get.offAllNamed('/login');
    } catch (e) {}
  }
}
