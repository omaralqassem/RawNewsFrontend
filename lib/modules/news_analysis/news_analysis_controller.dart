import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
  final details = Rxn<Map<String, dynamic>>();
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    _getArticle(Get.arguments.id);
    _parseArguments(Get.arguments);
  }

  Future<void> _getArticle(int id) async {
    try {
      isLoading.value = true;
      details.value = await _apiService.getArticleDetails(id);
      await _getCluster(details.value!['cluster_id']);
    } catch (e) {
      print("Error fetching article details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getCluster(int id) async {
    try {
      isLoading.value = true;
      final data = await _apiService.getCluster(id);
      rxCluster.value = NewsClusterModel.fromJson(data);
    } catch (e) {
      print("Error fetching cluster: $e");
    } finally {
      isLoading.value = false;
    }
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
      if (cluster == null || cluster.articles.isEmpty) return;

      final mainArticleId = cluster.articles.first.id;

      await _apiService.submitSummaryFeedback(
        articleId: mainArticleId,
        userRating: value == 2,
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

  Future<bool> submitArticleFeedback({
    required int articleId,
    required bool propagandaCorrect,
    String? correctedPropaganda,
    required bool statementCorrect,
    String? correctedStatement,
    required bool attributionCorrect,
    String? correctedAttribution,
    String? notes,
  }) async {
    try {
      await _apiService.submitFeedback(
        articleId: articleId,
        propagandaCorrect: propagandaCorrect,
        correctedPropaganda: correctedPropaganda,
        statementCorrect: statementCorrect,
        correctedStatement: correctedStatement,
        attributionCorrect: attributionCorrect,
        correctedAttribution: correctedAttribution,
        notes: notes,
      );

      Get.snackbar(
        "Feedback Received",
        "Thank you! Your feedback will help refine our AI models.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.15),
        colorText: Colors.green,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        "Submission Failed",
        "Could not submit feedback to server.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.15),
        colorText: Colors.red,
      );
      return false;
    }
  }
}
