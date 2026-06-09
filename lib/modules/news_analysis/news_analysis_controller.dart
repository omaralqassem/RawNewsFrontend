import 'package:get/get.dart';
import 'news_analysis_model.dart';

class NewsAnalysisController extends GetxController {
  final rxCluster = Rxn<NewsClusterModel>();
  final isLoading = false.obs;
  final selectedSourceA = 0.obs;
  final selectedSourceB = 1.obs;
  final isSaved = false.obs;

  final summaryRating = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final String? clusterId = Get.arguments as String?;
    fetchClusterAnalysis(clusterId ?? "default_id");
  }

  Future<void> fetchClusterAnalysis(String id) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      rxCluster.value = NewsClusterModel(
        id: id,
        title: "Global Space Coalition Launches Deep-Space Exploration Probe",
        category: "AEROSPACE",
        publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
        smartSummary:
            "The International Space Alliance has successfully sent the 'Aether-1' explorer into orbit. The mission's focus is atmospheric chemical analysis of exoplanets. While core technical objectives were completed perfectly, debate persists over its 20% budget overrun and a two-year delay.",
        neutralConsensus:
            "The 'Aether-1' deep-space probe has reached its target orbital trajectory. Official flight data confirms stable telemetry. The project represents a collaborative effort among 12 nations, despite pre-launch financial restructuring and logistical delays.",
        articles: [
          SourceArticleModel(
            id: "art_1",
            sourceName: "Global Tech Sentinel",
            author: "Marcus Vance",
            originalUrl: "https://example.com/sentinel",
            fullText:
                "In a stunning display of human ingenuity, the Aether-1 probe took flight today. This landmark launch sets a historic precedent for international space projects, keeping future timeline forecasts extremely optimistic.",
            biasScore: -0.6,
            biasLabel: "Leaning Positive / Progressive",
            comparativeExcerpt:
                "A stunning display of human ingenuity setting an optimistic historic precedent.",
          ),
          SourceArticleModel(
            id: "art_2",
            sourceName: "Financial Capital Report",
            author: "Helena Rostova",
            originalUrl: "https://example.com/capital",
            fullText:
                "The deeply delayed Aether-1 orbital mission finally launched. Marred by two years of bureaucratic stagnation and a massive budget inflation of 20%, financial analysts question whether the returns justify public funding.",
            biasScore: 0.8,
            biasLabel: "Leaning Critical / Financial Focus",
            comparativeExcerpt:
                "Marred by bureaucratic stagnation and a massive 20% budget inflation.",
          ),
        ],
      );
    } catch (e) {
      Get.snackbar("Error", "Could not fetch analysis updates");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSave() {
    isSaved.value = !isSaved.value;
  }

  void submitRating(int value) {
    summaryRating.value = value;
  }
}
