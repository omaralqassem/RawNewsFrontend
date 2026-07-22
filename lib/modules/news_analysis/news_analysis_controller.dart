import 'package:get/get.dart';
import 'package:rawnes/modules/NewsFeed/news_model.dart';
import 'news_analysis_model.dart';
import 'package:rawnes/core/services/api_service.dart';


class NewsAnalysisController extends GetxController {
  final rxCluster = Rxn<NewsClusterModel>();
  final isLoading = false.obs;
  final isSaved = false.obs;
  final summaryRating = 0.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is NewsModel) {
      // جاي من الـ NewsFeed
      _loadFromNewsModel(args);
    } else if (args is String) {
      // جاي من الـ Bookmarks
      fetchClusterAnalysis(args);
    } else {
      fetchClusterAnalysis('default_id');
    }
  }

  void _loadFromNewsModel(NewsModel news) {
    isLoading.value = true;
    rxCluster.value = NewsClusterModel(
      id: news.id.toString(),
      title: news.title,
      category: news.category ?? 'NEWS',
      publishedAt: DateTime.tryParse(news.publishedAt) ?? DateTime.now(),
      smartSummary: news.description,
      neutralConsensus: news.content,
      articles: [
        SourceArticleModel(
          id: '1',
          sourceName: news.source ?? 'Unknown Source',
          author: 'Unknown',
          originalUrl: news.url ?? '',
          fullText: news.content,
          biasScore: 0.0,
          biasLabel: 'Neutral',
          comparativeExcerpt: news.description,
        ),
      ],
    );
    isLoading.value = false;
  }

  Future<void> fetchClusterAnalysis(String id) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      // Mock data مؤقت
      rxCluster.value = NewsClusterModel(
        id: id,
        title: "Global Space Coalition Launches Deep-Space Exploration Probe",
        category: "AEROSPACE",
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        smartSummary: "The International Space Alliance has successfully sent the 'Aether-1' explorer into orbit.",
        neutralConsensus: "The 'Aether-1' deep-space probe has reached its target orbital trajectory.",
        articles: [
          SourceArticleModel(
            id: "art_1",
            sourceName: "Global Tech Sentinel",
            author: "Marcus Vance",
            originalUrl: "https://example.com/sentinel",
            fullText: "In a stunning display of human ingenuity, the Aether-1 probe took flight today.",
            biasScore: -0.6,
            biasLabel: "Leaning Positive / Progressive",
            comparativeExcerpt: "A stunning display of human ingenuity.",
          ),
          SourceArticleModel(
            id: "art_2",
            sourceName: "Financial Capital Report",
            author: "Helena Rostova",
            originalUrl: "https://example.com/capital",
            fullText: "The deeply delayed Aether-1 orbital mission finally launched.",
            biasScore: 0.8,
            biasLabel: "Leaning Critical / Financial Focus",
            comparativeExcerpt: "Marred by bureaucratic stagnation.",
          ),
        ],
      );
    } catch (e) {
      Get.snackbar("Error", "Could not fetch analysis");
    } finally {
      isLoading.value = false;
    }
  }

  //void toggleSave() => isSaved.value = !isSaved.value;
  Future<void> toggleSave() async {
  try {
    final cluster = rxCluster.value;
    if (cluster == null) return;

    final newsId = int.tryParse(cluster.id);
    if (newsId == null) return;

    await _apiService.toggleFavorite(newsId);
    isSaved.value = !isSaved.value;

    Get.snackbar(
      isSaved.value ? 'Saved ' : 'Removed',
      isSaved.value ? 'Added to bookmarks' : 'Removed from bookmarks',
      snackPosition: SnackPosition.BOTTOM,
    );
  } catch (e) {
    // لو قاعدة البيانات فاضية أو في خطأ
    isSaved.value = !isSaved.value;
    Get.snackbar(
      isSaved.value ? 'Saved ' : 'Removed',
      isSaved.value ? 'Added to bookmarks' : 'Removed from bookmarks',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
  void submitRating(int value) => summaryRating.value = value;
}