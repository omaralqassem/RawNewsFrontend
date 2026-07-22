import 'package:get/get.dart';
import 'package:rawnes/core/services/api_service.dart';
import 'news_model.dart';

class FeedController extends GetxController {
  final isLoading = false.obs;
  final newsList = <NewsModel>[].obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getAllNews();

      if (response.isEmpty) {
        // ← Mock data مؤقت لحد ما الـ backend يجهز
        newsList.assignAll(_mockNews());
      } else {
        newsList.assignAll(
          response.map((item) => NewsModel.fromJson(item)).toList(),
        );
      }
    } catch (e) {
      // ← حتى لو فشل الـ API اعرض الـ mock
      newsList.assignAll(_mockNews());
    } finally {
      isLoading.value = false;
    }
  }

  List<NewsModel> _mockNews() {
    return [
      NewsModel(
        id: 1,
        title: 'ارتفاع أسعار النفط عالمياً',
        description: 'شهدت أسعار النفط ارتفاعاً ملحوظاً بسبب زيادة الطلب العالمي',
        content: 'شهدت أسعار النفط ارتفاعاً ملحوظاً بسبب زيادة الطلب العالمي.',
        source: 'BBC Arabic',
        category: 'Economy',
        publishedAt: '2026-07-21T10:00:00Z',
      ),
      NewsModel(
        id: 2,
        title: 'تطورات الذكاء الاصطناعي في 2026',
        description: 'شركات التكنولوجيا تطلق نماذج جديدة أكثر كفاءة',
        content: 'شركات التكنولوجيا الكبرى تتسابق لإطلاق نماذج ذكاء اصطناعي جديدة.',
        source: 'Tech Daily',
        category: 'Technology',
        publishedAt: '2026-07-21T08:00:00Z',
      ),
      NewsModel(
        id: 3,
        title: 'اتفاقية سلام جديدة في الشرق الأوسط',
        description: 'محادثات السلام تحقق تقدماً ملموساً بين الأطراف',
        content: 'أعلنت الأطراف المعنية عن تقدم ملموس في محادثات السلام.',
        source: 'Al Jazeera',
        category: 'Politics',
        publishedAt: '2026-07-20T15:00:00Z',
      ),
      NewsModel(
        id: 4,
        title: 'الفضاء: مركبة جديدة تصل المريخ',
        description: 'وكالة ناسا تعلن نجاح مهمة استكشاف المريخ',
        content: 'أعلنت وكالة ناسا عن نجاح مهمتها الجديدة لاستكشاف المريخ.',
        source: 'NASA News',
        category: 'Science',
        publishedAt: '2026-07-20T12:00:00Z',
      ),
    ];
  }
}