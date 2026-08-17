import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'profile_model.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController usernameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  final selectedImagePath = "".obs;
  final isLoading = false.obs;
  final isProfileLoading = true.obs;
  final rxUser = Rxn<UserModel>();

  final selectedTopics = <String>[].obs;
  final List<String> availableTopics = [
    "سياسة",
    "تقنية",
    "أعمال",
    "علوم",
    "ثقافة",
    "رياضة",
    "صحة",
  ];

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    usernameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isProfileLoading.value = true;
      final response = await _apiService.getProfile();

      if (response.containsKey('email')) {
        final user = UserModel.fromJson(response);
        rxUser.value = user;
        usernameCtrl.text = user.username;
        emailCtrl.text = user.email;
        phoneCtrl.text = user.phone;
      } else {
        Get.snackbar('Error', 'Failed to load profile');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isProfileLoading.value = false;
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
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.single.path != null) {
        selectedImagePath.value = result.files.single.path!;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file');
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await _apiService.updateProfile({
        'username': usernameCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
      });

      if (response.containsKey('email')) {
        final user = UserModel.fromJson(response);
        rxUser.value = user;
        Get.snackbar('Success ✅', 'Profile updated successfully');
        Get.back();
      } else {
        Get.snackbar('Error', response.toString());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
