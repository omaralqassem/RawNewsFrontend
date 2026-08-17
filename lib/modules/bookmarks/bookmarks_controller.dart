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
      bookmarkedItems.assignAll(
        response.map((item) => BookmarkModel.fromJson(item)).toList(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookmarks');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeBookmark(int articleId) async {
    try {
      final response = await _apiService.toggleFavorite({'id': articleId});
      if (response['is_favorite'] == false) {
        bookmarkedItems.removeWhere((item) => item.articleId == articleId);
        Get.snackbar(
          'تم إلغاء الحفظ',
          'حذف الخبر من المحفوظات',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove bookmark');
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
