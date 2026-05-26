import 'package:get/get.dart';
import 'package:rawnes/core/theme/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}
