import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/modules/NewsFeed/news_model.dart';
import 'news_analysis_controller.dart';

class NewsAnalysisView extends GetView<NewsAnalysisController> {
  const NewsAnalysisView({super.key});

  Future<void> _launchArticleUrl(String urlString) async {
    if (urlString.isEmpty) {
      Get.snackbar("Notice", "No original link available for this article.");
      return;
    }

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Error", "Could not open link: $urlString");
      }
    } catch (e) {
      Get.snackbar("Error", "Invalid link format");
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "AI CLUSTER ANALYSIS",
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
            onPressed: () {
              Get.snackbar("Share", "Sharing cluster details...");
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: Obx(() {
        final cluster = controller.rxCluster.value;

        if (controller.isLoading.value || cluster == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.actionBlue,
              strokeWidth: 2,
            ),
          );
        }

        if (cluster.articles.isEmpty) {
          return const Center(child: Text("No articles found in this cluster"));
        }

        final mainArticle = cluster.articles.first;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (controller.rxQuery.value.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.actionBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.actionBlue.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Search: \"${controller.rxQuery.value}\"",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.actionBlue,
                        ),
                      ),
                      Text(
                        "Window: ${controller.rxTimeWindow.value}",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

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
                      "CLUSTER #${cluster.clusterId}",
                      style: const TextStyle(
                        color: AppColors.actionBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Text(
                    "${cluster.articles.length} Connected Sources",
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                mainArticle.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                  letterSpacing: -0.5,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionHeader("AI NEUTRAL SUMMARY", textPrimary),
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        (cluster.summary != null && cluster.summary!.isNotEmpty)
                            ? cluster.summary!
                            : "AI is currently aggregating consensus data across sources for this story cluster...",
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

              _buildSectionHeader(
                "PUBLISHERS & BIAS METRICS (${cluster.articles.length})",
                textPrimary,
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cluster.articles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
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
    NewsModel article,
    ThemeData theme,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
  ) {
    final reliabilityPercent = ((article.reliabilityScore ?? 0) * 100).toInt();
    final neutralityPercent = ((article.neutralityScore ?? 0) * 100).toInt();

    final rawPropaganda = article.propagandaLabel ?? 'neutral';
    final isNeutral = rawPropaganda.toLowerCase() == 'neutral';
    final propColor = isNeutral ? Colors.green : AppColors.errorRed;
    final propLabelText = rawPropaganda.replaceAll('_', ' ').toUpperCase();

    final statementType = (article.statementType ?? 'REPORTING').toUpperCase();
    final attributionLabel = (article.attributionLabel ?? 'UNSUPPORTED CLAIM')
        .replaceAll('_', ' ')
        .toUpperCase();

    String formattedDate = "Recently";
    try {
      if (article.publishedAt.isNotEmpty) {
        final dt = DateTime.parse(article.publishedAt);
        formattedDate =
            "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
      }
    } catch (_) {}

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          article.sourceName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (article.verified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          color: AppColors.actionBlue,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: propColor.withOpacity(0.1),
                    border: Border.all(color: propColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    propLabelText,
                    style: TextStyle(
                      color: propColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Text(
              article.title,
              style: TextStyle(
                fontSize: 13,
                color: textSecondary,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: AppColors.actionBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Reliability: $reliabilityPercent%",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.balance_rounded,
                        size: 14,
                        color: AppColors.actionBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Neutrality: $neutralityPercent%",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 12,
                      color: textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Type: $statementType",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 12,
                      color: textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Claim: $attributionLabel",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Published: $formattedDate",
                  style: TextStyle(
                    fontSize: 9,
                    color: textSecondary.withOpacity(0.7),
                  ),
                ),
                Text(
                  "Article ID: #${article.id}",
                  style: TextStyle(
                    fontSize: 9,
                    color: textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => _launchArticleUrl(article.url),
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
