import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'package:rawnes/core/services/storage_service.dart';
import 'news_model.dart';

class FeedController extends GetxController {
  final isLoading = false.obs;
  final newsList = <NewsModel>[].obs;
  final ApiService _apiService = ApiService();
  List<String> mutedSources = [];
  List<String> favSources = [];

  final selectedStatementType = ''.obs;
  final selectedNeutrality = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLatestNews();
  }

  Future<void> getPref() async {
    mutedSources = await (StorageService.getMutedSources()) ?? [];
    favSources = await (StorageService.getFavSources()) ?? [];
  }

  void applyFilters(String statementType, String neutrality) {
    selectedStatementType.value = statementType;
    selectedNeutrality.value = neutrality;
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    isLoading.value = true;
    try {
      await getPref();

      final response = await _apiService.getAllNews(
        statementType: selectedStatementType.value.isEmpty
            ? null
            : selectedStatementType.value,
        neutrality: selectedNeutrality.value.isEmpty
            ? null
            : selectedNeutrality.value,
      );

      final filteredResponse = response.where((item) {
        final sourceName = (item['source_name'] ?? item['source'] ?? '')
            .toString()
            .trim();

        if (sourceName.isEmpty) return true;

        return !mutedSources.any(
          (mutedSource) =>
              mutedSource.trim().toLowerCase() == sourceName.toLowerCase(),
        );
      }).toList();

      filteredResponse.sort((a, b) {
        final aSource = (a['source_name'] ?? a['source'] ?? '')
            .toString()
            .trim();
        final bSource = (b['source_name'] ?? b['source'] ?? '')
            .toString()
            .trim();

        final aIsFavorite = favSources.any(
          (favSource) =>
              favSource.trim().toLowerCase() == aSource.toLowerCase(),
        );
        final bIsFavorite = favSources.any(
          (favSource) =>
              favSource.trim().toLowerCase() == bSource.toLowerCase(),
        );

        if (aIsFavorite && !bIsFavorite) return -1;
        if (!aIsFavorite && bIsFavorite) return 1;
        return 0;
      });

      newsList.assignAll(
        filteredResponse.map((item) => NewsModel.fromJson(item)).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load news');
    } finally {
      isLoading.value = false;
    }
  }
}
