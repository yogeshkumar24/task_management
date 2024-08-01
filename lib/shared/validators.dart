class Validator {
  static String? nameValidator(String? value, String text) {
    if (value == null || value.isEmpty) {
      return 'Please enter $text';
    } else {
      return null;
    }
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    } else {
      // Regular expression for validating an email
      String pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
      RegExp regex = RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Please enter a valid email address';
      } else {
        return null;
      }
    }
  }
}
