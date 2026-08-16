import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'news_model.dart';

class FeedController extends GetxController {
  final isLoading = false.obs;
  final newsList = <NewsModel>[].obs;
  final ApiService _apiService = ApiService();

  final selectedStatementType = ''.obs;
  final selectedNeutrality = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLatestNews();
  }

  void applyFilters(String statementType, String neutrality) {
    selectedStatementType.value = statementType;
    selectedNeutrality.value = neutrality;
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getAllNews(
        statementType: selectedStatementType.value.isEmpty
            ? null
            : selectedStatementType.value,
        neutrality: selectedNeutrality.value.isEmpty
            ? null
            : selectedNeutrality.value,
      );

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
