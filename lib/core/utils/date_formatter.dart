import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static String transactionDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Hoje, ${DateFormat('HH:mm').format(date)}';
    }
    if (target == today.subtract(const Duration(days: 1))) {
      return 'Ontem, ${DateFormat('HH:mm').format(date)}';
    }
    return DateFormat("d 'de' MMM", 'pt_BR').format(date);
  }

  static String fullDate(DateTime date) {
    return DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(date);
  }

  static String monthYear(DateTime date) {
    final formatted = DateFormat('MMMM yyyy', 'pt_BR').format(date);
    if (formatted.isEmpty) return formatted;
    return formatted[0].toUpperCase() + formatted.substring(1);
  }
}
