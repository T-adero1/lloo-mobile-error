import 'package:get/get.dart';

class FormValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Field'} is required';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.length < minLength) {
      return '${fieldName ?? 'Field'} must be at least $minLength characters';
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength, [String? fieldName]) {
    if (value != null && value.length > maxLength) {
      return '${fieldName ?? 'Field'} must not exceed $maxLength characters';
    }
    return null;
  }
}
