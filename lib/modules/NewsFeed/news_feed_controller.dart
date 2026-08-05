import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'news_model.dart';

class FeedController extends GetxController {
  final isLoading = false.obs;
  final newsList = <NewsModel>[].obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getAllNews();
      newsList.assignAll(
        response.map((item) => NewsModel.fromJson(item)).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load news');
    } finally {
      isLoading.value = false;
    }
  }
}
