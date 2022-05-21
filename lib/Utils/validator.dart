import 'package:checkdigit/checkdigit.dart';

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
    var len = isbn.length;

    if (len == 10 && isbn10.validate(isbn)) {
      return null;
    }
    if (len == 13 && isbn13.validate(isbn)) {
      return null;
    }
    return errorMessage;
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
