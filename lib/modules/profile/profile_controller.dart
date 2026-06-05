import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rawnes/modules/home/home_controller.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameCtrl;
  late TextEditingController usernameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  final selectedImagePath = "".obs;
  final isLoading = false.obs;
  final selectedTopics = <String>[].obs;
  final List<String> availableTopics = [
    "POLITICS",
    "TECHNOLOGY",
    "BUSINESS",
    "SCIENCE",
    "CULTURE",
    "SPORTS",
    "HEALTH",
  ];

  late HomeController _homeController;

  @override
  void onInit() {
    super.onInit();
    _homeController = Get.find<HomeController>();

    final currentUser = _homeController.rxUser.value;

    nameCtrl = TextEditingController(text: currentUser?.name);
    emailCtrl = TextEditingController(text: currentUser?.email);
    phoneCtrl = TextEditingController(text: currentUser?.phone);

    if (currentUser?.preferredTopics != null) {
      selectedTopics.assignAll(currentUser!.preferredTopics);
    }
  }

  void toggleTopic(String topic) {
    if (selectedTopics.contains(topic)) {
      selectedTopics.remove(topic);
    } else {
      selectedTopics.add(topic);
    }
  }

  Future<void> pickProfilePhoto() async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        selectedImagePath.value = result.files.single.path!;
      }
    } catch (e) {
      Get.snackbar(
        "Error title",
        "failed to pick file",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      final currentUser = _homeController.rxUser.value;
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          name: nameCtrl.text.trim(),
          email: emailCtrl.text.trim(),
          phone: phoneCtrl.text.trim(),
          preferredTopics: selectedTopics.toList(),
          avatarUrl: selectedImagePath.value.isNotEmpty
              ? selectedImagePath.value
              : currentUser.avatarUrl,
        );

        _homeController.rxUser.value = updatedUser;
      }

      Get.back();
      Get.snackbar(
        "success title",
        "profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "error_title".tr,
        "failed_to_update_profile".tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
