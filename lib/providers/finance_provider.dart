import 'package:flutter/foundation.dart';
import 'package:finper_flutter/models/transaction.dart';
import 'package:finper_flutter/models/transaction_type.dart';

class FinanceProvider extends ChangeNotifier {
  FinanceProvider(); // Inicia vazio, as transações são adicionadas posteriormente

  final List<Transaction> _transactions = [];
  bool _isDarkMode = false;
  final String _userName = 'Ikaro';
  String _currency = 'BRL';

  List<Transaction> get transactions =>
      List.unmodifiable(_transactions);

  bool get isDarkMode => _isDarkMode;
  String get userName => _userName;
  String get currency => _currency;

  List<Transaction> get recentTransactions {
    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  List<Transaction> get monthTransactions {
    final now = DateTime.now();
    return _transactions.where((t) {
      return t.date.year == now.year && t.date.month == now.month;
    }).toList();
  }

  double get monthIncome => monthTransactions
      .where((t) => t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  double get monthExpenses => monthTransactions
      .where((t) => !t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => _transactions.fold(0, (sum, t) {
        return t.isIncome ? sum + t.amount : sum - t.amount;
      });

  double get monthSavings => monthIncome - monthExpenses;

  bool get isSaving => monthSavings >= 0;

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }
}