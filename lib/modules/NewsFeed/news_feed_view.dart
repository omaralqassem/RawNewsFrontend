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
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                color: AppColors.actionBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              "أحدث الأخبار",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => _showFilterBottomSheet(
                            context,
                            theme,
                            textPrimary,
                          ),
                          icon: Obx(
                            () => Icon(
                              Icons.tune_rounded,
                              color:
                                  controller
                                          .selectedStatementType
                                          .value
                                          .isNotEmpty ||
                                      controller
                                          .selectedNeutrality
                                          .value
                                          .isNotEmpty
                                  ? AppColors.actionBlue
                                  : textPrimary,
                            ),
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
                              arguments: article.id,
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

  void _showFilterBottomSheet(
    BuildContext context,
    ThemeData theme,
    Color textPrimary,
  ) {
    String tempStatementType = controller.selectedStatementType.value;
    String tempNeutrality = controller.selectedNeutrality.value;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تصفية الأخبار",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "نوع المحتوى",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        _buildFilterChip(
                          'الكل',
                          '',
                          tempStatementType,
                          (val) => setState(() => tempStatementType = val),
                          theme,
                        ),
                        _buildFilterChip(
                          'تقرير',
                          'reporting',
                          tempStatementType,
                          (val) => setState(() => tempStatementType = val),
                          theme,
                        ),
                        _buildFilterChip(
                          'رأي',
                          'opinion',
                          tempStatementType,
                          (val) => setState(() => tempStatementType = val),
                          theme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "مستوى الحياد",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        _buildFilterChip(
                          'الكل',
                          '',
                          tempNeutrality,
                          (val) => setState(() => tempNeutrality = val),
                          theme,
                        ),
                        _buildFilterChip(
                          'حيادي',
                          'high',
                          tempNeutrality,
                          (val) => setState(() => tempNeutrality = val),
                          theme,
                        ),
                        _buildFilterChip(
                          'متحيز',
                          'low',
                          tempNeutrality,
                          (val) => setState(() => tempNeutrality = val),
                          theme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.actionBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          controller.applyFilters(
                            tempStatementType,
                            tempNeutrality,
                          );
                          Get.back();
                        },
                        child: const Text(
                          "تطبيق الفلاتر",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String groupValue,
    Function(String) onSelected,
    ThemeData theme,
  ) {
    final isSelected = value == groupValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) onSelected(value);
      },
      selectedColor: AppColors.actionBlue.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? AppColors.actionBlue
            : theme.textTheme.bodyMedium?.color,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? AppColors.actionBlue
              : Colors.grey.withOpacity(0.3),
        ),
      ),
    );
  }
}
