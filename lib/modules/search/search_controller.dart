import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import '../NewsFeed/news_model.dart';

class SearchController extends GetxController {
  final searchQuery = "".obs;
  final isLoading = false.obs;
  late TextEditingController textController;
  final ApiService _apiService = ApiService();

  final trendingKeywords = <String>[
    "Space Launch",
    "Maritime Policy",
    "Open Weights",
    "Tech Regulations",
  ];

  final searchResults = <NewsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> performSearch(String query) async {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.getAllNews(search: query.trim());
      searchResults.assignAll(
        response.map((item) => NewsModel.fromJson(item)).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Search failed');
    } finally {
      isLoading.value = false;
    }
  }

  void selectTrendingKeyword(String keyword) {
    textController.text = keyword;
    performSearch(keyword);
  }

  void clearSearch() {
    textController.clear();
    performSearch("");
  }
}