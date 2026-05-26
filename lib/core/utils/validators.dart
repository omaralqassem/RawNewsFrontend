import 'package:get/get_utils/src/extensions/internacionalization.dart';

class Validators {
  static String? required(String? value) =>
      value == null || value.trim().isEmpty ? 'req_field'.tr : null;

  static String? name(String? value, {bool isLastName = false}) {
    if (value == null || value.trim().isEmpty) {
      return isLastName ? 'req_field'.tr : 'req_field'.tr;
    }
    if (value.trim().length < 2) return 'At least 2 characters';
    if (!RegExp(r'^[A-Z]').hasMatch(value.trim())) {
      return isLastName ? 'must_capital'.tr : 'must_capital'.tr;
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value.trim())) {
      return 'only_letters'.tr;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'enter_email'.tr;
    if (!RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value.trim())) {
      return 'enter_valid_email'.tr;
    }
    return null;
  }

  static String? syrianMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enter_phone'.tr;
    }
    if (!RegExp(r"^(?:\+963|0)?9\d{8}$").hasMatch(value.trim())) {
      return 'enter_valid_phone'.tr;
    }
    return null;
  }

  static String? emailOrSyrianMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'req_field'.tr;
    }
    if (RegExp(r'[a-zA-Z]').hasMatch(value)) return email(value);
    return syrianMobile(value);
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) return 'password_required'.tr;
    if (value.length < 6) return 'password_long'.tr;
    if (!value.contains(RegExp(r'[A-Z]'))) return 'password_upper'.tr;
    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value != password) return 'passwords_match'.tr;
    return null;
  }

  static String? birthdate(String? value) {
    if (value == null || value.trim().isEmpty) return 'req'.tr;
    if (!RegExp(r"^\d{4}-\d{2}-\d{2}$").hasMatch(value.trim())) {
      return 'birth_format'.tr;
    }
    final parsedDate = DateTime.tryParse(value.trim());
    if (parsedDate == null) return 'invalid_date'.tr;
    if (parsedDate.isAfter(DateTime.now())) return 'future_date'.tr;
    return null;
  }
}
