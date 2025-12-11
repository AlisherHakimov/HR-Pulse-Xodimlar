import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

extension StringExtention on String {
  bool? get isNumber => int.tryParse(this) != null;
}

extension DateFormatter on DateTime {
  String toLocalizedFormat() {
    final weekdayKey = _getWeekdayKey();
    final localizedWeekday = weekdayKey.tr();

    final formattedDate = DateFormat('dd.MM.yyyy').format(this);

    return '$localizedWeekday, $formattedDate';
  }

  String _getWeekdayKey() {
    switch (weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      default:
        return 'monday';
    }
  }
}

// Yoki String'dan to'g'ridan-to'g'ri
extension StringToDate on String {
  String toLocalizedDate() {
    try {
      final date = DateTime.parse(this);
      return date.toLocalizedFormat();
    } catch (e) {
      return this;
    }
  }
}
