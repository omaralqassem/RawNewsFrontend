import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final identifierCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));

      Get.offAllNamed('/home');
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToRegister() {
    Get.toNamed('/register');
  }

  @override
  void onClose() {
    identifierCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
