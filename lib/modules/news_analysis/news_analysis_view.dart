import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/modules/NewsFeed/news_model.dart';
import 'news_analysis_controller.dart';
import 'package:readmore/readmore.dart';

class NewsAnalysisView extends GetView<NewsAnalysisController> {
  const NewsAnalysisView({super.key});

  Future<void> _launchArticleUrl(String urlString) async {
    if (urlString.isEmpty) {
      Get.snackbar("تنبيه", "لا يوجد رابط أصلي متاح لهذا الخبر.");
      return;
    }

    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        Get.snackbar("خطأ", "تعذر فتح الرابط: $urlString");
      }
    } catch (e) {
      Get.snackbar("خطأ", "صيغة الرابط غير صحيحة");
    }
  }

  String _formatPropagandaAr(String? raw) {
    if (raw == null) return "محايد";
    final clean = raw.trim();
    if (clean.toLowerCase() == 'neutral') return "محايد (غير منحاز)";
    switch (clean) {
      case 'Loaded_Language':
        return "لغة مشحونة عاطفياً";
      case 'Name_Calling-Labeling':
        return "إطلاق ألقاب وتصنيفات";
      case 'Exaggeration-Minimisation':
        return "تضخيم أو تهوين الأحداث";
      case 'Doubt':
        return "إثارة الشكوك والتكذيب";
      case 'False_Dilemma-No_Choice':
        return "استقطاب وتخيير زائف";
      case 'Causal_Oversimplification':
        return "تبسيط مخل للأسباب";
      default:
        return clean.replaceAll('_', ' ');
    }
  }

  String _formatStatementTypeAr(String? raw) {
    if (raw == null) return "تقرير إخباري";
    if (raw.toLowerCase() == 'opinion') return "مقال رأي";
    return "تقرير إخباري";
  }

  String _formatAttributionAr(String? raw) {
    if (raw == null) return "ادعاء موثق";
    if (raw.toLowerCase().contains('unsupported')) return "ادعاء غير موثق";
    return "ادعاء موثق بمصدر";
  }

  void _showFeedbackBottomSheet(BuildContext context, NewsModel article) {
    bool propagandaCorrect = true;
    String selectedPropaganda = article.propagandaLabel;

    bool statementCorrect = true;
    String selectedStatement = article.statementType;

    bool attributionCorrect = true;
    String selectedAttribution = article.attributionLabel;

    final notesController = TextEditingController();

    final propagandaOptions = [
      {'key': 'Neutral', 'label': 'محايد (غير منحاز)'},
      {'key': 'propaganda', 'label': 'منحاز'},
      {'key': 'Loaded_Language', 'label': 'لغة مشحونة عاطفياً'},
      {'key': 'Name_Calling-Labeling', 'label': 'إطلاق ألقاب وتصنيفات'},
      {'key': 'Exaggeration-Minimisation', 'label': 'تضخيم أو تهوين الأحداث'},
      {'key': 'Doubt', 'label': 'إثارة الشكوك والتكذيب'},
      {'key': 'False_Dilemma-No_Choice', 'label': 'استقطاب وتخيير زائف'},
      {'key': 'Causal_Oversimplification', 'label': 'تبسيط مخل للأسباب'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final textPrimary = isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary;

              return Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 45,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "تصحيح وتحسين تحليل الخبر",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "خبر رقم: #${article.id} - المصدر: ${article.sourceName}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Divider(height: 24),

                      _buildSwitchTile(
                        title: "هل تقييم الانحياز صحيح؟",
                        subtitle:
                            "التصنيف الحالي: ${_formatPropagandaAr(article.propagandaLabel)}",
                        value: propagandaCorrect,
                        onChanged: (val) {
                          setModalState(() => propagandaCorrect = val);
                        },
                      ),
                      if (!propagandaCorrect) ...[
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value:
                              propagandaOptions.any(
                                (opt) => opt['key'] == selectedPropaganda,
                              )
                              ? selectedPropaganda
                              : 'Neutral',
                          decoration: const InputDecoration(
                            labelText: "اختر تصنيف الانحياز الصحيح",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: propagandaOptions
                              .map(
                                (opt) => DropdownMenuItem(
                                  value: opt['key']!,
                                  child: Text(
                                    opt['label']!,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null)
                              setModalState(() => selectedPropaganda = val);
                          },
                        ),
                      ],
                      const SizedBox(height: 16),

                      _buildSwitchTile(
                        title: "هل نوع النص صحيح؟",
                        subtitle:
                            "التصنيف الحالي: ${_formatStatementTypeAr(article.statementType)}",
                        value: statementCorrect,
                        onChanged: (val) {
                          setModalState(() => statementCorrect = val);
                        },
                      ),
                      if (!statementCorrect) ...[
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedStatement.toLowerCase() == 'opinion'
                              ? 'opinion'
                              : 'reporting',
                          decoration: const InputDecoration(
                            labelText: "اختر نوع النص الصحيح",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'reporting',
                              child: Text('تقرير إخباري'),
                            ),
                            DropdownMenuItem(
                              value: 'opinion',
                              child: Text('مقال رأي'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null)
                              setModalState(() => selectedStatement = val);
                          },
                        ),
                      ],
                      const SizedBox(height: 16),

                      _buildSwitchTile(
                        title: "هل إسناد الادعاء صحيح؟",
                        subtitle:
                            "التصنيف الحالي: ${_formatAttributionAr(article.attributionLabel)}",
                        value: attributionCorrect,
                        onChanged: (val) {
                          setModalState(() => attributionCorrect = val);
                        },
                      ),
                      if (!attributionCorrect) ...[
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: selectedAttribution.contains('unsupported')
                              ? 'unsupported_claim'
                              : 'supported_claim',
                          decoration: const InputDecoration(
                            labelText: "اختر نوع إسناد الادعاء الصحيح",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'supported_claim',
                              child: Text('ادعاء موثق بمصدر'),
                            ),
                            DropdownMenuItem(
                              value: 'unsupported_claim',
                              child: Text('ادعاء غير موثق'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null)
                              setModalState(() => selectedAttribution = val);
                          },
                        ),
                      ],
                      const SizedBox(height: 16),

                      TextField(
                        controller: notesController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "ملاحظات إضافية (اختياري)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.actionBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final success = await controller
                                .submitArticleFeedback(
                                  articleId: article.id,
                                  propagandaCorrect: propagandaCorrect,
                                  correctedPropaganda: propagandaCorrect
                                      ? null
                                      : selectedPropaganda,
                                  statementCorrect: statementCorrect,
                                  correctedStatement: statementCorrect
                                      ? null
                                      : selectedStatement,
                                  attributionCorrect: attributionCorrect,
                                  correctedAttribution: attributionCorrect
                                      ? null
                                      : selectedAttribution,
                                  notes: notesController.text.trim(),
                                );
                            if (success) {
                              Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            "إرسال التقييم والتصحيح",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
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
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          activeColor: AppColors.actionBlue,
          onChanged: onChanged,
        ),
      ],
    );
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
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "تحليل المجموعات بالذكاء الاصطناعي",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
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
                  size: 24,
                ),
                onPressed: controller.toggleSave,
              ),
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
            return const Center(
              child: Text(
                "لم يتم العثور على أخبار في هذه المجموعة",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (controller.rxQuery.value.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: AppColors.actionBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.actionBlue.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "بحث: \"${controller.rxQuery.value}\"",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.actionBlue,
                          ),
                        ),
                        Text(
                          "النطاق: ${controller.rxTimeWindow.value}",
                          style: TextStyle(
                            fontSize: 12,
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
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.actionBlue,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "مجموعة # ${cluster.clusterId}",
                        style: const TextStyle(
                          color: AppColors.actionBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Text(
                      "${cluster.articles.length} مصادر إخبارية متصلة",
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Text(
                  controller.details.value!['title'],
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1.4,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 26),

                _buildSectionHeader(
                  "الملخص المحايد بالذكاء الاصطناعي",
                  textPrimary,
                ),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          (cluster.summary != null &&
                                  cluster.summary!.isNotEmpty)
                              ? cluster.summary!
                              : "يقوم الذكاء الاصطناعي حالياً بتجميع البيانات وصياغة ملخص محايد لهذه القصة الإخبارية...",
                          style: TextStyle(
                            fontSize: 16,
                            color: textPrimary,
                            height: 1.7,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Divider(color: borderColor, height: 1),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "هل كان هذا الملخص محايداً ومفيداً؟",
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
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
                                      size: 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () => controller.submitRating(1),
                                  child: Obx(
                                    () => Icon(
                                      Icons.thumb_down_rounded,
                                      color: controller.summaryRating.value == 1
                                          ? AppColors.errorRed
                                          : textSecondary.withOpacity(0.5),
                                      size: 22,
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
                const SizedBox(height: 28),

                _buildSectionHeader("تفاصيل الخبر", textPrimary),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: borderColor, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: ReadMoreText(
                      (controller.details.value?['content']?.toString() ?? '')
                              .trim()
                              .isNotEmpty
                          ? controller.details.value!['content'].toString()
                          : "لا توجد تفاصيل متاحة لهذا الخبر.",
                      trimMode: TrimMode.Line,
                      trimLines: 4, // Number of lines to show before truncating
                      colorClickableText: Colors.blue,
                      trimCollapsedText: 'عرض المزيد',
                      trimExpandedText: 'عرض أقل',
                      moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.actionBlue,
                      ),
                      lessStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.actionBlue,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.lightText,
                        height: 1.7,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                _buildSectionHeader(
                  "المصادر والتقييم التحليلي (${cluster.articles.length})",
                  textPrimary,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cluster.articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildSourceCard(
                      context,
                      cluster.articles[index],
                      theme,
                      textPrimary,
                      textSecondary,
                      borderColor,
                    );
                  },
                ),
                const SizedBox(height: 28),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        children: [
          Container(width: 5, height: 18, color: AppColors.actionBlue),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard(
    BuildContext context,
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

    final arabicBiasLabel = _formatPropagandaAr(rawPropaganda);

    final statementTypeAr = _formatStatementTypeAr(article.statementType);
    final attributionLabelAr = _formatAttributionAr(article.attributionLabel);

    String formattedDate = "مؤخراً";
    try {
      if (article.publishedAt.isNotEmpty) {
        final dt = DateTime.parse(article.publishedAt);
        formattedDate =
            "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
      }
    } catch (_) {}

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
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
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (article.verified) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified,
                          color: AppColors.actionBlue,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: propColor.withOpacity(0.12),
                    border: Border.all(color: propColor.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    arabicBiasLabel,
                    style: TextStyle(
                      color: propColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              article.title,
              style: TextStyle(
                fontSize: 14.5,
                color: textSecondary,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: borderColor.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 16,
                        color: AppColors.actionBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "الموثوقية: $reliabilityPercent%",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.balance_rounded,
                        size: 16,
                        color: AppColors.actionBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "الحيادية: $neutralityPercent%",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 15,
                      color: textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "النوع: $statementTypeAr",
                      style: TextStyle(
                        fontSize: 12,
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
                      size: 15,
                      color: textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "الادعاء: $attributionLabelAr",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تاريخ النشر: $formattedDate",
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary.withOpacity(0.8),
                  ),
                ),
                Text(
                  "معرف الخبر: #${article.id}",
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary.withOpacity(0.8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _showFeedbackBottomSheet(context, article),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.rate_review_outlined,
                        size: 16,
                        color: AppColors.actionBlue,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "تصحيح وتعديل التحليل",
                        style: TextStyle(
                          color: AppColors.actionBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _launchArticleUrl(article.url),
                  child: const Row(
                    children: [
                      Text(
                        "قراءة الخبر الأصلي",
                        style: TextStyle(
                          color: AppColors.actionBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_outward_rounded,
                        size: 15,
                        color: AppColors.actionBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
