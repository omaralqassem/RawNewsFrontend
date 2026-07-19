import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/modules/Preferences/preferencesController.dart';

class PreferencesView extends GetView<PreferencesController> {
  const PreferencesView({super.key});

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
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          children: [
            Text(
              "إدارة المصادر الإخبارية",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _buildActionRow(
              title: "المصادر المفضلة والمحجوبة",
              subtitle:
                  "تحديد المصادر التي تظهر أولاً أو حجب مصادر معينة تماماً.",
              onTap: () =>
                  _showManageSourcesDialog(context, textPrimary, textSecondary),
              textPrimary: textPrimary,
              textSecondary: textSecondary,
            ),
            _buildDivider(borderColor),

            Obx(
              () => _buildDropdownTile<String>(
                title: "فلترة الانحياز (Bias Filtering)",
                subtitle:
                    "تحديد مستوى الانحياز المقبول للأخبار في الواجهة الرئيسية.",
                value: controller.biasFilterMode,
                items: const [
                  DropdownMenuItem(
                    value: "neutral_only",
                    child: Text("إظهار الأخبار الحيادية والمتوازنة فقط"),
                  ),
                  DropdownMenuItem(
                    value: "allow_all",
                    child: Text("السماح بجميع المستويات مع إظهار المؤشر"),
                  ),
                ],
                onChanged: controller.updateBiasFilterMode,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                borderColor: borderColor,
              ),
            ),
            const SizedBox(height: 36),

            Obx(
              () => _buildSwitchTile(
                title: "شريط الأخبار المتجدد",
                subtitle: "تفعيل شريط الأخبار المتدفق في الواجهات النشطة.",
                value: controller.showNewsTicker,
                onChanged: controller.updateShowNewsTicker,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
            Obx(() {
              if (!controller.showNewsTicker) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "مواضيع شريط الأخبار:",
                      style: TextStyle(
                        fontSize: 11,
                        color: textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: [
                        ...controller.newsTickerTopics.map((topic) {
                          return Chip(
                            label: Text(
                              topic,
                              style: const TextStyle(fontSize: 10),
                            ),
                            onDeleted: () =>
                                controller.removeTickerTopic(topic),
                          );
                        }),
                        ActionChip(
                          label: const Text(
                            "+ إضافة موضوع",
                            style: TextStyle(fontSize: 10),
                          ),
                          onPressed: () => _showAddTickerTopicDialog(context),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            _buildDivider(borderColor),

            Obx(
              () => _buildDropdownTile<String>(
                title: "طول الملخص الذكي",
                subtitle: "تحديد مستوى التفصيل المفضل للملخصات الآلية.",
                value: controller.summaryLength,
                items: const [
                  DropdownMenuItem(
                    value: "compact",
                    child: Text("مكثف جداً (نقاط أساسية)"),
                  ),
                  DropdownMenuItem(
                    value: "medium",
                    child: Text("متوسط (تحليل متوازن)"),
                  ),
                  DropdownMenuItem(
                    value: "detailed",
                    child: Text("تفصيلي (تحليل شامل)"),
                  ),
                ],
                onChanged: controller.updateSummaryLength,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                borderColor: borderColor,
              ),
            ),
            _buildDivider(borderColor),

            Obx(
              () => _buildSwitchTile(
                title: "الوضع الداكن (Dark Mode)",
                subtitle: "التبديل بين المظهر الداكن والمظهر الفاتح للتطبيق.",
                value: controller.isDarkMode,
                onChanged: controller.toggleTheme,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
            _buildDivider(borderColor),
          ],
        ),
      ),
    );
  }

  void _showAddEntityDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("إضافة كيان أو موضوع لمتابعته"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: "اسم الشخص، الدولة، أو المنظمة",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              controller.addPreferredEntity(textController.text);
              Get.back();
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }

  void _showAddTickerTopicDialog(BuildContext context) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("إضافة موضوع لشريط الأخبار"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "مثال: تكنولوجيا، رياضة"),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              controller.addTickerTopic(textController.text);
              Get.back();
            },
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }

  void _showManageSourcesDialog(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
  ) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("إدارة المصادر الإخبارية"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: "اسم المصدر (مثال: رويترز)",
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "الإجراءات المقترحة للمصدر المدخل:",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        controller.toggleFavoriteSource(textController.text);
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.star, size: 16),
                    label: const Text("تفضيل"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        controller.toggleMuteSource(textController.text);
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.volume_mute, size: 16),
                    label: const Text("حجب (Mute)"),
                  ),
                ],
              ),
              const Divider(),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "المصادر المفضلة الحالية (${controller.favoriteSources.length}):",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...controller.favoriteSources.map(
                      (src) => ListTile(
                        title: Text(src, style: const TextStyle(fontSize: 12)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 16),
                          onPressed: () => controller.toggleFavoriteSource(src),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "المصادر المحجوبة الحالية (${controller.mutedSources.length}):",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...controller.mutedSources.map(
                      (src) => ListTile(
                        title: Text(src, style: const TextStyle(fontSize: 12)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 16),
                          onPressed: () => controller.toggleMuteSource(src),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("إغلاق")),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: textSecondary.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.actionBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile<T>({
    required String title,
    required String subtitle,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required Color textPrimary,
    required Color textSecondary,
    required Color borderColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: textSecondary.withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    items: items,
                    onChanged: onChanged,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.actionBlue,
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                    dropdownColor: borderColor == AppColors.darkBorder
                        ? const Color(0xFF121212)
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: textSecondary.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.actionBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(Color borderColor) {
    return Container(height: 1.0, color: borderColor);
  }
}

class _PreferencesHeader extends StatelessWidget {
  final String index;
  final String title;

  const _PreferencesHeader({required this.index, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          "$index / ",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.actionBlue,
            fontFamily: "Courier",
          ),
        ),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: textSecondary,
          ),
        ),
      ],
    );
  }
}
