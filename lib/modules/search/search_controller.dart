import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'package:rawnes/modules/NewsFeed/news_model.dart';
import 'dart:async'; // Required for Timer

class SearchController extends GetxController {
  final ApiService apiService = ApiService();
  final textController = TextEditingController();

  var searchQuery = ''.obs;
  var isLoading = false.obs;

  var selectedTimeWindow = '7d'.obs;
  var searchResults = <ClusterModel>[].obs;

  Timer? _debounce;

  final List<String> trendingKeywords = [
    "المجلس العربي",
    "غزة",
    "سوريا",
    "الذكاء الاصطناعي",
  ];

  final List<Map<String, String>> timeWindows = [
    {'label': '1 Hour', 'value': '1h'},
    {'label': '1 Day', 'value': '1d'},
    {'label': '3 Days', 'value': '3d'},
    {'label': '7 Days', 'value': '7d'},
    {'label': '30 Days', 'value': '30d'},
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

    _debounce = Timer(const Duration(milliseconds: 1500), () {
      _executeSearch(query);
    });
  }

  Future<void> _executeSearch(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    try {
      final results = await apiService.searchNews(
        query,
        timeWindow: selectedTimeWindow.value,
      );
      searchResults.assignAll(results);
    } catch (e) {
      print("Search Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    textController.dispose();
    super.onClose();
  }
}
