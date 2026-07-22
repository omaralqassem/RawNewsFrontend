import 'package:get/get.dart';
import 'news_analysis_controller.dart';

class NewsAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsAnalysisController>(() => NewsAnalysisController());
  }
}