class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validateStudentId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your student ID';
    }
    return null;
  }

  static String? validateTeacherId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Teacher ID is required';
    }
    if (value.length < 3) {
      return 'Teacher ID must be at least 3 characters';
    }
    // Optional: Add pattern validation for Teacher ID format
    // if (!RegExp(r'^T\d+$').hasMatch(value)) {
    //   return 'Teacher ID should start with T followed by numbers';
    // }
    return null;
  }
}