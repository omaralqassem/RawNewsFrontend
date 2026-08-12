import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/modules/news_analysis/news_analysis_controller.dart';
import 'package:rawnes/modules/news_analysis/news_analysis_model.dart';
import 'package:rawnes/modules/news_analysis/news_analysis_view.dart';
import 'search_controller.dart' as local;

class SearchView extends GetView<local.SearchController> {
  const SearchView({super.key});

  String _formatTimeAgoAr(String dateStr) {
    if (dateStr.isEmpty) return "مؤخراً";
    try {
      final dt = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(dt);
      if (diff.inHours > 0) {
        return "منذ ${diff.inHours} ساعة";
      } else if (diff.inMinutes > 0) {
        return "منذ ${diff.inMinutes} دقيقة";
      } else if (diff.inDays > 0) {
        return "منذ ${diff.inDays} يوم";
      }
    } catch (_) {}
    return "مؤخراً";
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
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
                child: _buildSearchTextField(
                  theme,
                  borderColor,
                  textPrimary,
                  textSecondary,
                ),
              ),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: controller.timeWindows.map((tw) {
                      final isSelected =
                          controller.selectedTimeWindow.value == tw['value'];
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ChoiceChip(
                          label: Text(tw['label']!),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected)
                              controller.setTimeWindow(tw['value']!);
                          },
                          selectedColor: AppColors.actionBlue.withOpacity(0.15),
                          backgroundColor: theme.cardColor,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.actionBlue
                                : textSecondary,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.actionBlue
                                : borderColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  final query = controller.searchQuery.value;
                  final results = controller.searchResults;

                  if (controller.isLoading.value) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.actionBlue,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "يقوم الذكاء الاصطناعي بتجميع وتحليل المصادر...",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (query.trim().isEmpty) {
                    return _buildTrendingSection(
                      textPrimary,
                      textSecondary,
                      borderColor,
                    );
                  }

                  if (results.isEmpty) {
                    return _buildNoResultsState(
                      query,
                      textPrimary,
                      textSecondary,
                    );
                  }

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final cluster = results[index];
                      final mainArticle = cluster.articles.isNotEmpty
                          ? cluster.articles.first
                          : null;
                      if (mainArticle == null) return const SizedBox.shrink();

                      final timeAgoStr = _formatTimeAgoAr(
                        mainArticle.publishedAt,
                      );

                      return _buildAnalyzedResultCard(
                        context: context,
                        cluster: cluster,
                        sourceCount: cluster.articles.length,
                        timeAgo: timeAgoStr,
                        title: mainArticle.title,
                        description:
                            cluster.summary ??
                            "يقوم الذكاء الاصطناعي بتجميع بيانات التوافق...",
                        consensusLabel:
                            "مجموعة الذكاء الاصطناعي • ${cluster.articles.length} مصادر",
                        consensusColor: AppColors.actionBlue,
                        borderColor: borderColor,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTextField(
    ThemeData theme,
    Color borderColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: TextField(
        controller: controller.textController,
        onChanged: controller.performSearch,
        style: TextStyle(color: textPrimary, fontSize: 14),
        cursorColor: AppColors.actionBlue,
        decoration: InputDecoration(
          hintText: "ابحث في الموضوعات لعرض التحليل متعدد المصادر...",
          hintStyle: TextStyle(
            color: textSecondary.withOpacity(0.6),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: textSecondary.withOpacity(0.6),
            size: 22,
          ),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: Icon(Icons.clear_rounded, color: textSecondary, size: 20),
                onPressed: controller.clearSearch,
              );
            }
            return const SizedBox.shrink();
          }),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingSection(
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.actionBlue,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "موضوعات التحليل الأكثر تداولاً",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8.0,
            runSpacing: 10.0,
            children: controller.trendingKeywords.map((keyword) {
              return GestureDetector(
                onTap: () => controller.selectTrendingKeyword(keyword),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.actionBlue.withOpacity(0.08),
                    border: Border.all(
                      color: AppColors.actionBlue.withOpacity(0.25),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    keyword,
                    style: const TextStyle(
                      color: AppColors.actionBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(
    String query,
    Color textPrimary,
    Color textSecondary,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 52,
              color: textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "لم يتم العثور على موضوعات مجمعة لـ \"$query\"",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "جرب البحث عن 'المجلس العربي' أو 'سوريا' أو 'غزة' لعرض التحليل متعدد المصادر.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzedResultCard({
    required BuildContext context,
    required NewsClusterModel cluster,
    required int sourceCount,
    required String timeAgo,
    required String title,
    required String description,
    required String consensusLabel,
    required Color consensusColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final cardColor = Theme.of(context).cardTheme.color ?? Colors.transparent;

    return GestureDetector(
      onTap: () {
        Get.to(
          () => const NewsAnalysisView(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => NewsAnalysisController());
          }),
          arguments: {
            'query': controller.searchQuery.value,
            'time_window': controller.selectedTimeWindow.value,
            'cluster': cluster,
          },
        );
      },
      child: Container(
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
                  "موضوع مجمع • $sourceCount مصادر إخبارية",
                  style: const TextStyle(
                    color: AppColors.actionBlue,
                    fontSize: 11,
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
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: textSecondary, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: consensusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    consensusLabel,
                    style: TextStyle(
                      color: consensusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      "عرض التحليل الكامل",
                      style: TextStyle(
                        color: AppColors.actionBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.analytics_outlined,
                      size: 14,
                      color: AppColors.actionBlue,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
