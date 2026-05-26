import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawnes/core/constants/app_colors.dart';
import 'package:rawnes/core/utils/validators.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "EST. ${DateTime.now().year}",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const _EditorialMasthead(),
                  const SizedBox(height: 40),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "welcome_back".tr,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                          height: 1.1,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "login_inst".tr,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: textSecondary,
                        ),
                      ),
                      const SizedBox(height: 36),

                      _UnderlineTextField(
                        hintText: "email_phone".tr,
                        icon: Icons.alternate_email_rounded,
                        controller: controller.identifierCtrl,
                        validator: Validators.emailOrSyrianMobile,
                        textColor: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                        hintColor: textSecondary.withOpacity(0.6),
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 24),

                      Obx(
                        () => _UnderlineTextField(
                          hintText: "password".tr,
                          icon: Icons.lock_outline_rounded,
                          controller: controller.passwordCtrl,
                          isPassword: true,
                          obscureText: controller.isPasswordHidden.value,
                          onTogglePassword: controller.togglePasswordVisibility,
                          textColor: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          hintColor: textSecondary.withOpacity(0.6),
                          borderColor: borderColor,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'password_required'.tr;
                            }
                            return null;
                          },
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Get.toNamed('/forgot-password'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "FORGOT KEY?",
                            style: TextStyle(
                              color: AppColors.actionBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Obx(
                        () => _EditorialActionButton(
                          isLoading: controller.isLoading.value,
                          onPressed: controller.login,
                          label: "login".tr,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: TextButton(
                          onPressed: controller.navigateToRegister,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: "${"dont_have_account".tr.toUpperCase()}  ",
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 11,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w600,
                              ),
                              children: const [
                                TextSpan(
                                  text: "REGISTER",
                                  style: TextStyle(
                                    color: AppColors.actionBlue,
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditorialMasthead extends StatelessWidget {
  const _EditorialMasthead();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 1.5)),
      ),
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "RAW",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
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
                    letterSpacing: 4.0,
                    color: textPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(width: 3, height: 48, color: AppColors.actionBlue),
        ],
      ),
    );
  }
}

class _UnderlineTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;

  const _UnderlineTextField({
    required this.hintText,
    required this.icon,
    required this.textColor,
    required this.hintColor,
    required this.borderColor,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePassword,
    this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText.toUpperCase(),
        hintStyle: TextStyle(
          color: hintColor,
          fontSize: 11,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
        prefixIcon: Icon(icon, color: hintColor, size: 16),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 24,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: hintColor,
                  size: 16,
                ),
                onPressed: onTogglePassword,
              )
            : null,
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.actionBlue, width: 2.0),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorRed, width: 2.0),
        ),
      ),
      validator: validator,
    );
  }
}

class _EditorialActionButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;

  const _EditorialActionButton({
    required this.isLoading,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    const double borderRadiusValue = 10.0;
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: AppColors.accentGradient,
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.arrow_right_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
