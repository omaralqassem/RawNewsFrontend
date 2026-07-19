import 'package:get/get.dart';
import 'package:rawnes/modules/Preferences/preferencesController.dart';

class PreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferencesController>(() => PreferencesController());
  }
}
