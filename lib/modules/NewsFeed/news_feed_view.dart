import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/modules/NewsFeed/news_feed_controller.dart';
import 'package:rawnes/modules/home/home_controller.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({super.key});

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

    return RefreshIndicator(
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
                        "LATEST NEWS",
                        style: TextStyle(
                          fontSize: 16,
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
                            strokeWidth: 1.5,
                          ),
                        ),
                      );
                    }

                    if (controller.latestNewsList.isEmpty) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: Text("No articles available")),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.latestNewsList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final article = controller.latestNewsList[index];

                        return _buildStandardNewsCard(
                          context: context,
                          sourceName: article['source'],
                          timeAgo: article['timeAgo'],
                          title: article['title'],
                          description: article['desc'],
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
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
          Get.snackbar(
            "Navigation Error",
            "Search tab is currently unavailable",
          );
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
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              "Search keywords, topics, sources...",
              style: TextStyle(
                fontSize: 13,
                color: textSecondary.withOpacity(0.6),
                fontWeight: FontWeight.w500,
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
                sourceName.toUpperCase(),
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
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(fontSize: 12.5, color: textSecondary, height: 1.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
