import 'package:get/get.dart';

class AboutController extends GetxController {
  final appVersion = "1.0.0".obs;
  final buildNumber = "24".obs;
  final aiEngineStatus = "OPERATIONAL".obs;
  final supportEmail = "editorial@rawnews.com";

  Future<void> contactSupport() async {
    try {
      Get.snackbar(
        "contact_us".tr,
        "${"opening mail client"} $supportEmail",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error title",
        "Failed to open email client",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
