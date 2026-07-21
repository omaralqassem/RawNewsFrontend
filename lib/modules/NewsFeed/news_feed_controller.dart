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

    print('=== NEWS DEBUG ===');
    print('Response: $response');
    print('Length: ${response.length}');
    print('==================');

      newsList.assignAll(
        response.map((item) => NewsModel.fromJson(item)).toList(),
      );
    } catch (e) {
    print('=== NEWS ERROR ===');
    print(e.toString());
    print('==================');

    Get.snackbar('Error', 'Failed to load news');
      Get.snackbar('Error', 'Failed to load news');
    } finally {
      isLoading.value = false;
    }
  }
}