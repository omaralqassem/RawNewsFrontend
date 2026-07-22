import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'bookmarks_model.dart';

class BookmarksController extends GetxController {
  final isLoading = false.obs;
  final bookmarkedItems = <BookmarkModel>[].obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchBookmarks();
  }

  Future<void> fetchBookmarks() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getFavorites();

    print('=== BOOKMARKS DEBUG ===');
    print('Response: $response');
    print('Length: ${response.length}');
    print('=======================');

      bookmarkedItems.assignAll(
        response.map((item) => BookmarkModel.fromJson(item)).toList(),
      );
    } catch (e) {

    print('=== BOOKMARKS ERROR ===');
    print(e.toString());
    print('=======================');

      Get.snackbar('Error', 'Failed to load bookmarks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeBookmark(int newsId) async {
    try {
      await _apiService.removeFavorite(newsId);
      bookmarkedItems.removeWhere((item) => item.newsId == newsId);
      Get.snackbar(
        'Removed',
        'Removed from bookmarks',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove bookmark');
    }
  }

  Future<void> toggleBookmark(int newsId) async {
    try {
      await _apiService.toggleFavorite(newsId);
      fetchBookmarks();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update bookmark');
    }
  }

  void shareItem(String title) {
    Get.snackbar(
      'Share',
      'Sharing: "$title"',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}