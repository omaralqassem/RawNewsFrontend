import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'package:rawnes/modules/NewsFeed/news_model.dart';
import 'news_analysis_model.dart';

class NewsAnalysisController extends GetxController {
  final rxCluster = Rxn<NewsClusterModel>();
  final isLoading = false.obs;
  final isSaved = false.obs;
  final summaryRating = 0.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;

    if (args is NewsModel) {
      _loadFromNewsModel(args);
    } else if (args is String) {
      fetchClusterAnalysis(args);
    } else {
      fetchClusterAnalysis('default_id');
    }
  }

  void _loadFromNewsModel(NewsModel news) {
    isLoading.value = true;
    rxCluster.value = NewsClusterModel(
      id: news.id.toString(),
      clusterId: news.clusterId,
      title: news.title,
      category: 'NEWS',
      publishedAt: DateTime.tryParse(news.publishedAt) ?? DateTime.now(),
      smartSummary: news.content ?? news.title,
      summary: news.content,
      neutralConsensus: news.content ?? '',
      articles: [news],  // NewsModel دغري
    );
    isLoading.value = false;
  }

  Future<void> fetchClusterAnalysis(String id) async {
    isLoading.value = true;
    try {
      final response = await _apiService.getNewsById(int.parse(id));
      final news = NewsModel.fromJson(response);

      rxCluster.value = NewsClusterModel(
        id: news.id.toString(),
        clusterId: news.clusterId,
        title: news.title,
        category: 'NEWS',
        publishedAt: DateTime.tryParse(news.publishedAt) ?? DateTime.now(),
        smartSummary: news.content ?? news.title,
        summary: news.content,
        neutralConsensus: news.content ?? '',
        articles: [news],  // NewsModel دغري
      );
    } catch (e) {
      Get.snackbar("Error", "Could not fetch article");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleSave() async {
    try {
      final cluster = rxCluster.value;
      if (cluster == null) return;

      final articleId = int.tryParse(cluster.id);
      if (articleId == null) return;

      final response = await _apiService.toggleFavorite(articleId);
      isSaved.value = response['is_favorite'] ?? false;

      Get.snackbar(
        isSaved.value ? 'Saved' : 'Removed',
        response['message'] ?? '',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isSaved.value = !isSaved.value;
      Get.snackbar(
        isSaved.value ? 'Saved' : 'Removed',
        isSaved.value ? 'Added to bookmarks' : 'Removed from bookmarks',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> submitRating(int value) async {
    summaryRating.value = value;
    try {
      final cluster = rxCluster.value;
      if (cluster == null) return;

      final articleId = int.tryParse(cluster.id);
      if (articleId == null) return;

      await _apiService.submitFeedback(
        articleId: articleId,
        propagandaCorrect: value == 2,
        statementCorrect: value == 2,
        attributionCorrect: value == 2,
        notes: value == 2 ? 'User rated helpful' : 'User rated not helpful',
      );
    } catch (e) {
      
    }
  }
}