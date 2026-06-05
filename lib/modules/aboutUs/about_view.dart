import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textPrimary,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "About us".toUpperCase(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: borderColor, height: 1.0),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "RAW",
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2.0,
                      color: textPrimary,
                    ),
                    children: const [
                      TextSpan(
                        text: ".",
                        style: TextStyle(color: AppColors.actionBlue),
                      ),
                      TextSpan(
                        text: "NEWS",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "TRUTH UNFILTERED",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5.0,
                    color: textPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            const _EditorialSectionHeader(index: "01", title: "OUR MISSION"),
            const SizedBox(height: 16),
            Text(
              "At RAW.NEWS, our mission is to eliminate media manipulation. By aggregating global coverage and analyzing bias with AI, we extract the core facts to deliver objective truth, unfiltered.",
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: textPrimary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 36),

            const _EditorialSectionHeader(
              index: "02",
              title: "SYSTEM ARCHITECTURE",
            ),
            const SizedBox(height: 16),

            Obx(
              () => _SystemInfoRow(
                label: "CLIENT VERSION",
                value:
                    "v${controller.appVersion.value} (b${controller.buildNumber.value})",
              ),
            ),
            _DividerLine(color: borderColor),

            Obx(
              () => _SystemInfoRow(
                label: "BIAS ENGINE",
                value: controller.aiEngineStatus.value,
                valueColor: Colors.green,
              ),
            ),
            _DividerLine(color: borderColor),

            _SystemInfoRow(
              label: "CONTACT SUPPORT",
              value: controller.supportEmail,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _EditorialSectionHeader extends StatelessWidget {
  final String index;
  final String title;

  const _EditorialSectionHeader({required this.index, required this.title});

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
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: AppColors.actionBlue,
            fontFamily: "Courier",
          ),
        ),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SystemInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SystemInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: textSecondary,
            ),
          ),
          Text(
            value.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
              fontFamily: "Courier",
              color: valueColor ?? textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  final Color color;
  const _DividerLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1.0, color: color);
  }
}
