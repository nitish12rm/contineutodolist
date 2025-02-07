class Validators {
  // Validate Email
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email cannot be empty";
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  // Validate Password (Min 6 chars)
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password cannot be empty";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  // Validate Task Title
  static String? validateTaskTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return "Task title cannot be empty";
    }
    return null;
  }

  // Validate Task Description
  static String? validateTaskDescription(String? description) {
    if (description == null || description.trim().isEmpty) {
      return "Task description cannot be empty";
    }
    return null;
  }
}
