import 'package:get/get.dart';

class FeedController extends GetxController {
  final isLoading = false.obs;

  final latestNewsList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      latestNewsList.assignAll([
        {
          "id": "news_001",
          "source": "Global Tech Daily",
          "timeAgo": "10 Mins Ago",
          "title":
              "Aether-1 Probe Successfully Transmits First Batch of Exoplanet Telemetry",
          "desc":
              "Scientists at the station confirmed receiving the initial telemetry packet containing vital molecular and atmospheric readings from the exoplanet orbit.",
        },
        {
          "id": "news_002",
          "source": "Maritime Post",
          "timeAgo": "1 Hour Ago",
          "title":
              "New Border Shipping Clearances Underway in Southern Terminal",
          "desc":
              "Customs officials report minor delays as port systems adjust to the newly authorized cargo verification protocols introduced this morning.",
        },
        {
          "id": "news_003",
          "source": "Silicon Valley Wire",
          "timeAgo": "3 Hours Ago",
          "title":
              "Research Team Releases Open Weights for Neuron-8B Language Model",
          "desc":
              "An independent deep learning collective has made their latest language model weights fully public, sparking widespread community experimentation.",
        },
      ]);
    } catch (e) {
      Get.snackbar("Error", "Failed to load latest news");
    } finally {
      isLoading.value = false;
    }
  }
}
