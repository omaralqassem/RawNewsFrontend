import 'package:get/get.dart';

class BookmarksController extends GetxController {
  final isLoading = false.obs;

  final bookmarkedItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookmarks();
  }

  Future<void> fetchBookmarks() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      bookmarkedItems.assignAll([
        {
          "id": "aether_probe_101",
          "sources": 3,
          "timeAgo": "2 Hours Ago",
          "title":
              "Global Space Alliance Launches Deep-Space Exploration Probe",
          "desc":
              "Analysis of telemetry readings. Covers perspectives celebrating historical scientific progress versus financial scrutiny regarding budget overruns.",
          "consensus": "Balanced Consensus",
          "consensusColor": "green",
        },
      ]);
    } catch (e) {
      Get.snackbar("Error", "Failed to load bookmarks");
    } finally {
      isLoading.value = false;
    }
  }

  void removeBookmark(String id) {
    bookmarkedItems.removeWhere((item) => item['id'] == id);
    Get.snackbar(
      "Removed",
      "Item removed from your bookmarks",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Share item mock functionality
  void shareItem(String title) {
    Get.snackbar(
      "Share",
      "Opening share sheet for: \"$title\"",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
