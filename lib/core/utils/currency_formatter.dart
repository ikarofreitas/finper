import 'package:intl/intl.dart';

abstract final class CurrencyFormatter {
  static String format(double value, {String currency = 'BRL'}) {
    final symbol = switch (currency) {
      'USD' => r'$',
      'EUR' => '€',
      _ => r'R$',
    };
    final formatter = NumberFormat.currency(
      locale: currency == 'BRL' ? 'pt_BR' : 'en_US',
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(value);
  }
}
