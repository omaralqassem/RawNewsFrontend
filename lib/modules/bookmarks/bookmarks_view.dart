import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'bookmarks_controller.dart';
import '../news_analysis/news_analysis_view.dart';
import '../news_analysis/news_analysis_controller.dart';

class BookmarksView extends GetView<BookmarksController> {
  const BookmarksView({super.key});

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.actionBlue,
              strokeWidth: 1.5,
            ),
          );
        }

        if (controller.bookmarkedItems.isEmpty) {
          return _buildEmptyState(textPrimary, textSecondary);
        }

        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          itemCount: controller.bookmarkedItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = controller.bookmarkedItems[index];

            Color consensusColor = AppColors.actionBlue;
            if (item['consensusColor'] == 'green')
              consensusColor = Colors.green;
            if (item['consensusColor'] == 'red')
              consensusColor = AppColors.errorRed;

            return _buildBookmarkedCard(
              context: context,
              clusterId: item['id'],
              sourceCount: item['sources'],
              timeAgo: item['timeAgo'],
              title: item['title'],
              description: item['desc'],
              consensusLabel: item['consensus'],
              consensusColor: consensusColor,
              borderColor: borderColor,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            );
          },
        );
      }),
    );
  }

  Widget _buildEmptyState(Color textPrimary, Color textSecondary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 54,
              color: textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              "No bookmarks saved",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkedCard({
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
                  "SAVED ANALYSIS • $sourceCount SOURCES",
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
                Row(
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.share_outlined,
                        color: textSecondary,
                        size: 18,
                      ),
                      onPressed: () => controller.shareItem(title),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.bookmark_remove_rounded,
                        color: AppColors.errorRed,
                        size: 18,
                      ),
                      onPressed: () => controller.removeBookmark(clusterId),
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
