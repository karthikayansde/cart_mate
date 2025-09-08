import 'package:flutter/services.dart';
// goals
// block Emoji
// block profanity and Hate Speech (optional)
// block special characters
// limit char count
// block next line
// block urls and links
// sql injection codes
// allow only needed characters

class AppInputFormatters {
  // --- Regular Expressions ---
  // static final RegExp alphabeticRegExp = RegExp(r'[a-zA-Z\s]');
  // static final RegExp blockWhiteSpaceRegExp = RegExp(r'\s');
  static final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
  static final RegExp emailRegExpText = RegExp(r'[a-zA-Z0-9@._-]');
  static final RegExp allowLettersNumbersAndSpaces = RegExp(r'[a-zA-Z0-9\s]');

  // --- Single Formatters ---
  // static final TextInputFormatter allowDigitsOnly = FilteringTextInputFormatter.digitsOnly;
  // static final TextInputFormatter denySpaces = FilteringTextInputFormatter.deny(blockWhiteSpaceRegExp);
  static final TextInputFormatter emailFormat = FilteringTextInputFormatter.allow(emailRegExpText);
  static final TextInputFormatter allowLettersNumbersAndSpacesOnlyFormatter = FilteringTextInputFormatter.allow(allowLettersNumbersAndSpaces);
  static TextInputFormatter limitedText({required int maxLength}) {
    return LengthLimitingTextInputFormatter(maxLength);
  }
  // --- Methods for Group Formatters ---
  static List<TextInputFormatter> email()=>[
    emailFormat,
  ];
}

class MaxNumericValueFormatter extends TextInputFormatter {
  final double maxValue;
  final int decimalPlaces;
  late final RegExp validCharacters;

  MaxNumericValueFormatter({
    required this.maxValue,
    required this.decimalPlaces,
  }) {
    validCharacters = RegExp(r'^\d*\.?\d{0,' '$decimalPlaces' r'}$');
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;

    if (newText.isEmpty) return newValue;
    if (!validCharacters.hasMatch(newText)) return oldValue;

    final parsedValue = double.tryParse(newText);
    if (parsedValue == null) return oldValue;

    // Prevent decimals if equal to maxValue
    if (parsedValue == maxValue && newText.contains('.')) return oldValue;

    // Reject values above maxValue
    if (parsedValue > maxValue) return oldValue;

    return newValue;
  }
}

// import 'package:flutter/services.dart';
//
// class AppInputFormatters {
//   // --- Regular Expressions ---
//   // Allow
//   static final RegExp alphanumericAndSpacesRegExp = RegExp(r'[a-zA-Z0-9\s]');
//   static final RegExp emailAllowedCharactersRegExp = RegExp(r'[a-zA-Z0-9@._-]');
//
//   // Block
//   static final RegExp emojiRegExp = RegExp(r'\p{Emoji}', unicode: true);
//   static final RegExp profanityRegExp = RegExp(r'badword1|badword2', caseSensitive: false); // Add your profanity list here
//   static final RegExp specialCharactersRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
//   static final RegExp urlsRegExp = RegExp(
//       r'(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?');
//   static final RegExp sqlInjectionRegExp = RegExp(
//       r'(select|insert|update|delete|drop|union|--|;)', caseSensitive: false);
//
//   // --- Single Formatters ---
//   static final TextInputFormatter blockEmojis = FilteringTextInputFormatter.deny(emojiRegExp);
//   static final TextInputFormatter blockSpecialCharacters = FilteringTextInputFormatter.deny(specialCharactersRegExp);
//   static final TextInputFormatter blockNewlines = FilteringTextInputFormatter.deny(RegExp(r'\n'));
//   static final TextInputFormatter blockUrls = FilteringTextInputFormatter.deny(urlsRegExp);
//   static final TextInputFormatter blockSqlInjection = FilteringTextInputFormatter.deny(sqlInjectionRegExp);
//   static final TextInputFormatter blockProfanity = FilteringTextInputFormatter.deny(profanityRegExp);
//   static final TextInputFormatter allowLettersNumbersAndSpacesOnlyFormatter =
//   FilteringTextInputFormatter.allow(alphanumericAndSpacesRegExp);
//   static final TextInputFormatter emailFormat =
//   FilteringTextInputFormatter.allow(emailAllowedCharactersRegExp);
//
//   // --- Methods for Group Formatters ---
//   /// Formatter for fields like names or titles
//   static List<TextInputFormatter> generalText({int? maxLength}) {
//     List<TextInputFormatter> formatters = [
//       blockEmojis,
//       blockSpecialCharacters,
//       blockNewlines,
//       blockUrls,
//       blockSqlInjection,
//       allowLettersNumbersAndSpacesOnlyFormatter,
//     ];
//     if (maxLength != null) {
//       formatters.add(LengthLimitingTextInputFormatter(maxLength));
//     }
//     return formatters;
//   }
//
//   /// Formatter for email fields
//   static List<TextInputFormatter> email() {
//     return [
//       emailFormat,
//       blockNewlines,
//       LengthLimitingTextInputFormatter(100),
//     ];
//   }
// }