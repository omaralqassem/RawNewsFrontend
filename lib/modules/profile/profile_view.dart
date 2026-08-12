import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/core/utils/widgets.dart';
import 'package:rawnes/modules/home/home_controller.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
            "تعديل الملف الشخصي",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: textPrimary,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(color: borderColor, height: 1.0),
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            if (controller.isProfileLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.actionBlue),
              );
            }
            return Form(
              key: controller.formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Obx(() {
                          final imagePath = controller.selectedImagePath.value;
                          final globalUser =
                              Get.find<HomeController>().rxUser.value;

                          ImageProvider? profileImage;
                          if (imagePath.isNotEmpty) {
                            profileImage = FileImage(File(imagePath));
                          } else if (globalUser?.avatarUrl != null &&
                              globalUser!.avatarUrl!.isNotEmpty) {
                            profileImage = NetworkImage(globalUser.avatarUrl!);
                          }

                          return Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.actionBlue,
                                width: 1.5,
                              ),
                              image: profileImage != null
                                  ? DecorationImage(
                                      image: profileImage,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: profileImage == null
                                ? const Icon(
                                    Icons.person_outline_rounded,
                                    color: AppColors.actionBlue,
                                    size: 44,
                                  )
                                : null,
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: GestureDetector(
                            onTap: controller.pickProfilePhoto,
                            child: Container(
                              height: 32,
                              width: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.actionBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "تحديث الصورة الشخصية",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  const EditorialSectionHeader(
                    index: "01",
                    title: "بيانات الحساب",
                  ),
                  const SizedBox(height: 16),

                  UnderlineTextField(
                    hintText: "الاسم الكامل",
                    icon: Icons.person_outline_rounded,
                    controller: controller.usernameCtrl,
                    textColor: textPrimary,
                    hintColor: textSecondary.withOpacity(0.6),
                    borderColor: borderColor,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  UnderlineTextField(
                    hintText: "البريد الإلكتروني",
                    icon: Icons.mail_outline_rounded,
                    controller: controller.emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textColor: textPrimary,
                    hintColor: textSecondary.withOpacity(0.6),
                    borderColor: borderColor,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'البريد الإلكتروني مطلوب';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'البريد الإلكتروني غير صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  UnderlineTextField(
                    hintText: "رقم الهاتف",
                    icon: Icons.phone_android_rounded,
                    controller: controller.phoneCtrl,
                    keyboardType: TextInputType.phone,
                    textColor: textPrimary,
                    hintColor: textSecondary.withOpacity(0.6),
                    borderColor: borderColor,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'رقم الهاتف مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 36),

                  const EditorialSectionHeader(
                    index: "02",
                    title: "الموضوعات والاهتمامات",
                  ),
                  const SizedBox(height: 16),

                  Obx(
                    () => Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.availableTopics.map((topic) {
                        final isSelected = controller.selectedTopics.contains(
                          topic,
                        );
                        return ChoiceChip(
                          label: Text(
                            topic,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: isSelected
                                  ? Colors.white
                                  : textPrimary.withOpacity(0.8),
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.actionBlue,
                          backgroundColor: theme.scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.actionBlue
                                  : borderColor,
                              width: 1.0,
                            ),
                          ),
                          onSelected: (_) => controller.toggleTopic(topic),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 48),

                  Obx(
                    () => EditorialActionButton(
                      isLoading: controller.isLoading.value,
                      onPressed: controller.updateProfile,
                      label: "حفظ التغييرات",
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
