import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/modules/NewsFeed/news_feed_controller.dart';
import 'package:rawnes/modules/home/home_controller.dart';
import 'package:rawnes/routes/app_routes.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

  String _formatTimeAgoAr(String dateStr) {
    if (dateStr.isEmpty) return "مؤخراً";
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inMinutes < 60) {
        final mins = diff.inMinutes <= 0 ? 1 : diff.inMinutes;
        return "منذ $mins دقيقة";
      } else if (diff.inHours < 24) {
        return "منذ ${diff.inHours} ساعة";
      } else if (diff.inDays < 7) {
        return "منذ ${diff.inDays} يوم";
      } else {
        return "${dt.day}/${dt.month}/${dt.year}";
      }
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: RefreshIndicator(
        onRefresh: () => controller.fetchLatestNews(),
        color: AppColors.actionBlue,
        backgroundColor: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchShortcut(theme, borderColor, textSecondary),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "أحدث الأخبار",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            color: textPrimary,
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.actionBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      if (controller.isLoading.value) {
                        return const SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.actionBlue,
                              strokeWidth: 2.0,
                            ),
                          ),
                        );
                      }

                      if (controller.newsList.isEmpty) {
                        return const SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              "لا توجد مقالات إخبارية متاحة حالياً",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.newsList.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final article = controller.newsList[index];

                          return GestureDetector(
                            onTap: () => Get.toNamed(
                              Routes.NEWS_DETAIL,
                              arguments: article,
                            ),
                            child: _buildStandardNewsCard(
                              context: context,
                              sourceName: article.sourceName,
                              timeAgo: _formatTimeAgoAr(article.publishedAt),
                              title: article.title,
                              description: article.content ?? '',
                              borderColor: borderColor,
                              textPrimary: textPrimary,
                              textSecondary: textSecondary,
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchShortcut(
    ThemeData theme,
    Color borderColor,
    Color textSecondary,
  ) {
    return GestureDetector(
      onTap: () {
        try {
          final homeController = Get.find<HomeController>();
          homeController.changeTabIndex(1);
        } catch (e) {
          Get.snackbar("خطأ في التنقل", "علامة تبويب البحث غير متاحة حالياً");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: textSecondary.withOpacity(0.6),
              size: 22,
            ),
            const SizedBox(width: 12),
            Text(
              "ابحث عن الكلمات المفتاحية، الموضوعات، المصادر...",
              style: TextStyle(
                fontSize: 13,
                color: textSecondary.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandardNewsCard({
    required BuildContext context,
    required String sourceName,
    required String timeAgo,
    required String title,
    required String description,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sourceName,
                style: const TextStyle(
                  color: AppColors.actionBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                timeAgo,
                style: TextStyle(
                  color: textSecondary.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              height: 1.4,
            ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: textSecondary, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
