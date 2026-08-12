import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'package:rawnes/modules/NewsFeed/news_model.dart';
import 'news_analysis_model.dart';

class NewsAnalysisController extends GetxController {
  final rxCluster = Rxn<NewsClusterModel>();
  final rxQuery = ''.obs;
  final rxTimeWindow = ''.obs;
  final isLoading = false.obs;
  final isSaved = false.obs;
  final summaryRating = 0.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _parseArguments(Get.arguments);
  }

  void _parseArguments(dynamic args) {
    if (args == null) return;

    if (args is Map<String, dynamic>) {
      rxQuery.value = args['query']?.toString() ?? '';
      rxTimeWindow.value = args['time_window']?.toString() ?? '';

      final clusterArg = args['cluster'];

      if (clusterArg is NewsClusterModel) {
        rxCluster.value = clusterArg;
      } else if (clusterArg is Map<String, dynamic>) {
        rxCluster.value = NewsClusterModel.fromJson(clusterArg);
      } else if (args.containsKey('cluster_id')) {
        rxCluster.value = NewsClusterModel.fromJson(args);
      }
    } else if (args is NewsClusterModel) {
      rxCluster.value = args;
    } else if (args is NewsModel) {
      _loadFromNewsModel(args);
    }
  }

  void _loadFromNewsModel(NewsModel news) {
    rxCluster.value = NewsClusterModel(
      clusterId: news.clusterId,
      summary: news.content,
      articles: [news],
    );
  }

  Future<void> toggleSave() async {
    try {
      final cluster = rxCluster.value;
      if (cluster == null || cluster.articles.isEmpty) return;

      final articleId = cluster.articles.first.id;
      final response = await _apiService.toggleFavorite(articleId);
      isSaved.value = response['is_favorite'] ?? false;

      Get.snackbar(
        isSaved.value ? 'Saved' : 'Removed',
        response['message'] ?? '',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isSaved.value = !isSaved.value;
    }
  }

  Future<void> submitRating(int value) async {
    summaryRating.value = value;
    try {
      final cluster = rxCluster.value;
      if (cluster == null) return;

      await _apiService.submitSummaryFeedback(
        clusterId: cluster.clusterId,
        userRating: value,
        generatedSummary: cluster.summary,
      );

      Get.snackbar(
        "Feedback Sent",
        "Thank you for rating!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("Error submitting feedback: $e");
    }
  }
}
