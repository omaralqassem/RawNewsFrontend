import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'search_controller.dart' as local;
import '../news_analysis/news_analysis_view.dart';
import '../news_analysis/news_analysis_controller.dart';

class SearchView extends GetView<local.SearchController> {
  const SearchView({super.key});

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

    return GestureDetector(
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

            Expanded(
              child: Obx(() {
                final query = controller.searchQuery.value;
                final results = controller.searchResults;

                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.actionBlue,
                      strokeWidth: 1.5,
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

                    Color consensusColor = AppColors.actionBlue;
                    if (cluster['consensusColor'] == 'green')
                      consensusColor = Colors.green;
                    if (cluster['consensusColor'] == 'red')
                      consensusColor = AppColors.errorRed;

                    return _buildAnalyzedResultCard(
                      context: context,
                      clusterId: cluster['id'],
                      sourceCount: cluster['sources'],
                      timeAgo: cluster['timeAgo'],
                      title: cluster['title'],
                      description: cluster['desc'],
                      consensusLabel: cluster['consensus'],
                      consensusColor: consensusColor,
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
        style: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
        cursorColor: AppColors.actionBlue,
        decoration: InputDecoration(
          hintText: "Search topics to view multi-source analysis...",
          hintStyle: TextStyle(
            color: textSecondary.withOpacity(0.5),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: textSecondary.withOpacity(0.6),
            size: 20,
          ),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: Icon(Icons.clear_rounded, color: textSecondary, size: 18),
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
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "TRENDING ANALYSIS TOPICS",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
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
                    color: AppColors.actionBlue.withOpacity(0.05),
                    border: Border.all(
                      color: AppColors.actionBlue.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    keyword,
                    style: const TextStyle(
                      color: AppColors.actionBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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
              size: 48,
              color: textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "No synthesized topic found for \"$query\"",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Try looking up 'Space', 'Maritime', or 'AI' to find structured publisher analysis.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzedResultCard({
    required BuildContext context,
    required String clusterId,
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
          arguments: clusterId,
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
                  "CONVERGED TOPIC • $sourceCount SOURCES",
                  style: const TextStyle(
                    color: AppColors.actionBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: textSecondary.withOpacity(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textPrimary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(fontSize: 12, color: textSecondary, height: 1.5),
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
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: consensusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    consensusLabel.toUpperCase(),
                    style: TextStyle(
                      color: consensusColor,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      "VIEW FULL ANALYSIS",
                      style: TextStyle(
                        color: AppColors.actionBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.analytics_outlined,
                      size: 12,
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
