import 'package:flutter/services.dart';

class AppInputFormatters {
  // --- Regular Expressions ---
  // static final RegExp alphabeticRegExp = RegExp(r'[a-zA-Z\s]');
  // static final RegExp blockWhiteSpaceRegExp = RegExp(r'\s');
  static final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
  static final RegExp emailRegExpText = RegExp(r'[a-zA-Z0-9@._-]');
  static final RegExp doubleRegExpText = RegExp(r'^\d{0,9}$');//9999.999

  // --- Single Formatters ---
  // static final TextInputFormatter allowDigitsOnly = FilteringTextInputFormatter.digitsOnly;
  // static final TextInputFormatter denySpaces = FilteringTextInputFormatter.deny(blockWhiteSpaceRegExp);
  static final TextInputFormatter emailFormat = FilteringTextInputFormatter.allow(emailRegExpText);
  static final TextInputFormatter uomFormat = FilteringTextInputFormatter.allow(doubleRegExpText);
  static TextInputFormatter limitedText({required int maxLength}) {
    return LengthLimitingTextInputFormatter(maxLength);
  }

  // --- Methods for Group Formatters ---
  static List<TextInputFormatter> email()=>[
    emailFormat,
  ];
}


// Custom TextInputFormatter that restricts the input to a maximum value of 999.99.
class MaxNumericValueFormatter extends TextInputFormatter {
  static final RegExp _validCharacters = RegExp(r'^\d*\.?\d{0,2}$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String newText = newValue.text;

    // If the new value is empty, allow it.
    if (newText.isEmpty) {
      return newValue;
    }

    // Check if the new value matches the allowed pattern (numbers and up to two decimal places).
    if (!_validCharacters.hasMatch(newText)) {
      // If not, revert to the old value.
      return oldValue;
    }

    // Handle the maximum value logic.
    try {
      final double? parsedValue = double.tryParse(newText);
      if (parsedValue == null) {
        return oldValue;
      }

      // Allow 1000 as a valid integer.
      if (parsedValue == 1000) {
        // If the value is 1000, ensure there is no decimal point.
        if (newText.contains('.')) {
          return oldValue;
        }
        return newValue;
      }

      // If the value is greater than 1000, reject it.
      if (parsedValue > 1000) {
        return oldValue;
      }

      // If the value is between 0 and 1000 (exclusive), allow it.
      return newValue;
    } catch (e) {
      // Catch any parsing errors and revert to the old value.
      return oldValue;
    }
  }
}