import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import '../../../core/services/storage_service.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  final ApiService _apiService = ApiService();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
  if (!formKey.currentState!.validate()) {
    return;
  }

  isLoading.value = true;

  try {
    final response =
        await _apiService.login(
      email: identifierCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    );

    if (response.containsKey('access')) {
      await StorageService.saveTokens(
        access: response['access'],
        refresh: response['refresh'],
      );

      Get.snackbar(
        'Success',
        'Login Successful',
      );

      Get.offAllNamed('/home');
    } else {
      Get.snackbar(
        'Login Failed',
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

  void navigateToRegister() {
    Get.toNamed('/sign-up');
  }

  @override
  void onClose() {
    identifierCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
