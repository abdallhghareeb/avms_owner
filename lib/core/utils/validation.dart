class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    // Regex to ensure email contains @gmail.com
    const pattern = r'^[a-zA-Z0-9._%+-]+@gmail\.com$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid Gmail address';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Basic phone number regex (you can adjust this according to your needs)
    const pattern = r'^\d{10}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
