import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  final AuthService _authService = AuthService();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

Future<void> register() async {
  if (!formKey.currentState!.validate()) {
    return;
  }

  isLoading.value = true;

  try {
    final response =
        await _authService.register(
      username: nameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    );

    if (response.containsKey('message')) {
      Get.snackbar(
        'Success',
        response['message'],
        duration: const Duration(
          seconds: 5,
        ),
      );

      Get.back();
    } else {
      Get.snackbar(
        'Error',
        response.toString(),
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      e.toString(),
    );
  } finally {
    isLoading.value = false;
  }
}


  void navigateToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
