import 'package:flutter/services.dart';

class AppInputFormatters {
  // --- Regular Expressions ---
  // static final RegExp alphabeticRegExp = RegExp(r'[a-zA-Z\s]');
  // static final RegExp blockWhiteSpaceRegExp = RegExp(r'\s');
  static final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
  static final RegExp emailRegExpText = RegExp(r'[a-zA-Z0-9@._-]');

  // --- Single Formatters ---
  // static final TextInputFormatter allowDigitsOnly = FilteringTextInputFormatter.digitsOnly;
  // static final TextInputFormatter denySpaces = FilteringTextInputFormatter.deny(blockWhiteSpaceRegExp);
  static final TextInputFormatter emailFormat = FilteringTextInputFormatter.allow(emailRegExpText);
  static TextInputFormatter limitedText({required int maxLength}) {
    return LengthLimitingTextInputFormatter(maxLength);
  }

  // --- Methods for Group Formatters ---
  static List<TextInputFormatter> email()=>[
    emailFormat,
  ];
}