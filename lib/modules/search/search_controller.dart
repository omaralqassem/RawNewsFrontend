import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final searchQuery = "".obs;
  final isLoading = false.obs;
  late TextEditingController textController;

  final trendingKeywords = <String>[
    "Space Launch",
    "Maritime Policy",
    "Open Weights",
    "Tech Regulations",
  ];

  final List<Map<String, dynamic>> _analyzedClustersDataset = [
    {
      "id": "aether_probe_101",
      "sources": 3,
      "timeAgo": "2 Hours Ago",
      "title": "Global Space Alliance Launches Deep-Space Exploration Probe",
      "desc":
          "Analysis of telemetry readings. Covers perspectives celebrating historical scientific progress versus financial scrutiny regarding budget overruns.",
      "consensus": "Balanced Consensus",
      "consensusColor": "green",
    },
    {
      "id": "global_trade_202",
      "sources": 5,
      "timeAgo": "4 Hours Ago",
      "title":
          "New Maritime Shipping Regulations Take Effect Across Major Ports",
      "desc":
          "Synthesis of trade updates. Contrasts warnings from global logistics operators on inflation with regulatory arguments for long-term ecological balance.",
      "consensus": "Slight Bias Detected",
      "consensusColor": "blue",
    },
    {
      "id": "tech_ai_303",
      "sources": 4,
      "timeAgo": "Yesterday",
      "title": "New AI Architecture Released under Open-Source Licensing",
      "desc":
          "Compilation of developer praise on technical transparency versus administrative concerns about safety, data misuse, and synthetic text hazards.",
      "consensus": "Highly Polarized",
      "consensusColor": "red",
    },
  ];

  final searchResults = <Map<String, dynamic>>[].obs;

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

  void performSearch(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      final lowercaseQuery = query.toLowerCase();
      final filtered = _analyzedClustersDataset.where((cluster) {
        final titleMatch = cluster['title'].toString().toLowerCase().contains(
          lowercaseQuery,
        );
        final descMatch = cluster['desc'].toString().toLowerCase().contains(
          lowercaseQuery,
        );
        return titleMatch || descMatch;
      }).toList();

      searchResults.assignAll(filtered);
      isLoading.value = false;
    });
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
