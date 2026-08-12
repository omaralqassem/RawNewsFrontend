import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'package:rawnes/modules/news_analysis/news_analysis_model.dart';

class SearchController extends GetxController {
  final ApiService apiService = ApiService();
  final textController = TextEditingController();

  var searchQuery = ''.obs;
  var isLoading = false.obs;
  var selectedTimeWindow = '3d'.obs;

  var searchResults = <NewsClusterModel>[].obs;

  Timer? _debounce;

  final List<String> trendingKeywords = [
    "المجلس العربي",
    "غزة",
    "سوريا",
    "الذكاء الاصطناعي",
  ];

  final List<Map<String, String>> timeWindows = [
    {'label': 'ساعة واحدة', 'value': '1h'},
    {'label': 'يوم واحد', 'value': '1d'},
    {'label': '3 أيام', 'value': '3d'},
    {'label': '7 أيام', 'value': '7d'},
    {'label': '30 يوم', 'value': '30d'},
  ];

  void setTimeWindow(String value) {
    selectedTimeWindow.value = value;
    if (searchQuery.value.trim().isNotEmpty) {
      _executeSearch(searchQuery.value);
    }
  }

  void clearSearch() {
    textController.clear();
    searchQuery.value = '';
    searchResults.clear();
    _debounce?.cancel();
  }

  void selectTrendingKeyword(String keyword) {
    textController.text = keyword;
    _executeSearch(keyword);
  }

  void performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 800), () {
      _executeSearch(query);
    });
  }

  Future<void> _executeSearch(String query) async {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    try {
      final SearchResponseModel? response = await apiService.searchNews(
        query,
        timeWindow: selectedTimeWindow.value,
      );

      if (response != null && response.clusters.isNotEmpty) {
        searchResults.assignAll(response.clusters);
      } else {
        searchResults.clear();
      }
    } catch (e) {
      print("Search Execution Error: $e");
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void openClusterAnalysis(NewsClusterModel cluster) {
    Get.toNamed(
      '/news-analysis',
      arguments: {
        'query': searchQuery.value,
        'time_window': selectedTimeWindow.value,
        'cluster': cluster,
      },
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    textController.dispose();
    super.onClose();
  }
}
