import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    await _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await StorageService.getAccessToken();

    if (token != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }
}