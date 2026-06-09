import 'package:get/get.dart';
import 'home_controller.dart';
import 'package:rawnes/modules/NewsFeed/news_feed_controller.dart';
import 'package:rawnes/modules/search/search_controller.dart';
import 'package:rawnes/modules/bookmarks/bookmarks_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FeedController>(() => FeedController());
    Get.lazyPut<SearchController>(() => SearchController());
    Get.lazyPut<BookmarksController>(() => BookmarksController());
  }
}
