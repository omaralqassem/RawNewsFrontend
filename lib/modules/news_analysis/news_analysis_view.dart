import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'news_analysis_controller.dart';
import 'news_analysis_model.dart';

class NewsAnalysisView extends GetView<NewsAnalysisController> {
  const NewsAnalysisView({super.key});

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
      appBar: AppBar(
        title: Text(
          "ANALYSIS",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isSaved.value
                    ? Icons.bookmark
                    : Icons.bookmark_border_rounded,
                color: controller.isSaved.value
                    ? AppColors.actionBlue
                    : textPrimary,
              ),
              onPressed: controller.toggleSave,
            ),
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: textPrimary),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.actionBlue,
              strokeWidth: 2,
            ),
          );
        }

        final cluster = controller.rxCluster.value;
        if (cluster == null) {
          return const Center(child: Text("No analysis available"));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.actionBlue, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      cluster.category,
                      style: const TextStyle(
                        color: AppColors.actionBlue,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Text(
                    "4 Hours Ago",
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                cluster.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                  letterSpacing: -0.5,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader("SMART SUMMARY", textPrimary),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        cluster.smartSummary,
                        style: TextStyle(
                          fontSize: 14,
                          color: textPrimary,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: borderColor, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Was this analysis helpful?",
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => controller.submitRating(2),
                                child: Obx(
                                  () => Icon(
                                    Icons.thumb_up_rounded,
                                    color: controller.summaryRating.value == 2
                                        ? AppColors.actionBlue
                                        : textSecondary.withOpacity(0.5),
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              GestureDetector(
                                onTap: () => controller.submitRating(1),
                                child: Obx(
                                  () => Icon(
                                    Icons.thumb_down_rounded,
                                    color: controller.summaryRating.value == 1
                                        ? AppColors.errorRed
                                        : textSecondary.withOpacity(0.5),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader("NEUTRAL OUTLINE", textPrimary),
              Card(
                margin: EdgeInsets.zero,
                color: AppColors.actionBlue.withOpacity(0.06),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    cluster.neutralConsensus,
                    style: TextStyle(
                      fontSize: 14,
                      color: textPrimary,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader("PUBLISHERS & BIAS METRICS", textPrimary),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cluster.articles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildSourceCard(
                    cluster.articles[index],
                    theme,
                    textPrimary,
                    textSecondary,
                    borderColor,
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(width: 4, height: 16, color: AppColors.actionBlue),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard(
    SourceArticleModel article,
    ThemeData theme,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  article.sourceName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                Text(
                  article.biasLabel,
                  style: const TextStyle(
                    color: AppColors.actionBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              article.fullText,
              style: TextStyle(fontSize: 13, color: textSecondary, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Left leaning",
                      style: TextStyle(
                        color: textSecondary.withOpacity(0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Neutral",
                      style: TextStyle(
                        color: textSecondary.withOpacity(0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Right leaning",
                      style: TextStyle(
                        color: textSecondary.withOpacity(0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Align(
                      alignment: Alignment(article.biasScore, 0),
                      child: Container(
                        width: 12,
                        height: 12,
                        transform: Matrix4.translationValues(0, -3, 0),
                        decoration: const BoxDecoration(
                          color: AppColors.actionBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "READ ORIGINAL ARTICLE",
                    style: TextStyle(
                      color: AppColors.actionBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_outward_rounded,
                    size: 12,
                    color: AppColors.actionBlue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
