import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'package:rawnes/modules/NewsFeed/news_model.dart';

class NewsAnalysisController extends GetxController {
  final rxCluster = Rxn<ClusterModel>();
  final isLoading = false.obs;
  final isSaved = false.obs;
  final summaryRating = 0.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args is ClusterModel) {
      rxCluster.value = args;
    } else if (args is NewsModel) {
      _loadFromSingleNewsModel(args);
    }
  }

  void _loadFromSingleNewsModel(NewsModel news) {
    rxCluster.value = ClusterModel(
      clusterId: news.clusterId ?? news.id,
      summary: news.content,
      articles: [news],
    );
  }

  Future<void> toggleSave() async {
    try {
      final cluster = rxCluster.value;
      if (cluster == null || cluster.articles.isEmpty) return;

      final newsId = cluster.articles.first.id;

      await _apiService.toggleFavorite(newsId);
      isSaved.value = !isSaved.value;

      Get.snackbar(
        isSaved.value ? 'Saved' : 'Removed',
        isSaved.value ? 'Added to bookmarks' : 'Removed from bookmarks',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isSaved.value = !isSaved.value;
    }
  }

  Future<void> submitRating(int value) async {
    summaryRating.value = value;
    final cluster = rxCluster.value;

    if (cluster != null && cluster.articles.isNotEmpty) {
      try {
        await _apiService.submitSummaryFeedback(
          clusterId: cluster.articles.first.id,
          userRating: value,
          generatedSummary: cluster.summary,
        );
        Get.snackbar("Feedback Sent", "Thank you for helping improve the AI.");
      } catch (e) {
        print("Feedback error: $e");
      }
    }
  }
}
