import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final phoneFormatter = MaskTextInputFormatter(
  mask: '(##) ###-##-##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

final cardFormatter = MaskTextInputFormatter(
  mask: '#### #### #### ####',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);
final cardDateFormatter = MaskTextInputFormatter(
  mask: '##/##',
  filter: {"#": RegExp(r'[0-9]')},
  type: MaskAutoCompletionType.lazy,
);

extension PhoneNumberFormatter on String {
  String get toFormattedPhoneNumber {
    String cleaned = replaceAll(RegExp(r'\D'), '');
    return cleaned;
  }
}

final mailRegExp = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

bool isValidEmail(String email) {
  String pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}

extension MoneyFormat on String {
  String get moneyFormat {
    // Convert to fixed decimal places
    int decimalDigits = 2;
    final fixedString = double.parse(this).toStringAsFixed(decimalDigits);

    // Split into integer and decimal parts
    final parts = fixedString.split('.');
    String integerPart = parts[0];
    final decimalPart = parts.length > 1
        ? '.${parts[1]}'
        : '.${'0' * decimalDigits}';

    // Add thousands separators
    final buffer = StringBuffer();
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      buffer.write(integerPart[i]);
      count++;
      if (count % 3 == 0 && i > 0 && integerPart[i - 1] != '-') {
        buffer.write(',');
      }
    }
    // Reverse to get correct order
    final formattedInteger = buffer.toString().split('').reversed.join();

    // Combine currency symbol, integer part, and decimal part
    return '$formattedInteger';
  }
}

extension PhoneFormatter on String {
  String get toUzbekPhoneFormat {
    if (isEmpty) return '';
    return '${substring(0, 4)} ${substring(4, 6)} ${substring(6, 9)}-${substring(9, 11)}-${substring(11, 13)}';
  }
}
