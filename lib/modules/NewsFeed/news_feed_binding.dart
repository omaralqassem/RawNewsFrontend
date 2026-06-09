import 'package:get/get.dart';
import 'package:rawnes/modules/NewsFeed/news_feed_controller.dart';

class FeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedController>(() => FeedController());
  }
}
