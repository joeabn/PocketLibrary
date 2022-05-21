class Validator {
  static String? required({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'This field can\'t be empty';
    }

    return null;
  }

  static String? validateISBN({required String? isbn}) {
    const errorMessage = "Please enter a valid ISBN";
    if (isbn == null || isbn.isEmpty) {
      return null;
    }

    if (isbn.length != 10) {
      return errorMessage;
    }

    try {
      int.parse(isbn);
    } catch (e) {
      return errorMessage;
    }
    var sum = 0;
    for (int i = 10; i != 0; i--) {
      sum += (int.parse(isbn[i - 1]) * i);
    }

    if (sum % 11 != 0) {
      return errorMessage;
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }

    return null;
  }
}
