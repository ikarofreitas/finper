import 'package:flutter/foundation.dart';
import 'package:finper_flutter/models/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FinanceProvider extends ChangeNotifier {
  FinanceProvider() {
    loadTransactions();
    loadSettings();
  }

  final List<Transaction> _transactions = [];

  bool _isDarkMode = false;
  String _userName = 'Usuário';
  String _currency = 'BRL';

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  bool get isDarkMode => _isDarkMode;
  String get userName => _userName;
  String get currency => _currency;

  bool get hasUser {
  return _userName.trim().isNotEmpty &&
      _userName != 'Usuário';
}

  // ===========================
  // CONFIGURAÇÕES
  // ===========================

  Future<void> loadSettings() async {
    final box = Hive.box('settings');

    _userName = box.get(
      'userName',
      defaultValue: 'Usuário',
    );

    _currency = box.get(
      'currency',
      defaultValue: 'BRL',
    );

    _isDarkMode = box.get(
      'theme',
      defaultValue: false,
    );

    notifyListeners();
  }

  Future<void> saveSettings({
    required String userName,
    required String currency,
    required bool isDarkMode,
  }) async {
    final box = Hive.box('settings');

    await box.put('userName', userName);
    await box.put('currency', currency);
    await box.put('theme', isDarkMode);

    _userName = userName;
    _currency = currency;
    _isDarkMode = isDarkMode;

    notifyListeners();
  }

  bool get isFirstAccess {
    final box = Hive.box('settings');
    return !box.containsKey('userName');
  }

  Future<void> updateTheme(bool isDark) async {
    _isDarkMode = isDark;

    final box = Hive.box('settings');
    await box.put('theme', isDark);

    notifyListeners();
  }

  Future<void> updateCurrency(String currency) async {
    _currency = currency;

    final box = Hive.box('settings');
    await box.put('currency', currency);

    notifyListeners();
  }

  // ===========================
  // TRANSAÇÕES
  // ===========================

  List<Transaction> get recentTransactions {
    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    return sorted.take(5).toList();
  }

  List<Transaction> get monthTransactions {
    final now = DateTime.now();

    return _transactions.where((t) {
      return t.date.year == now.year &&
          t.date.month == now.month;
    }).toList();
  }

  List<double> get last30DaysBalance {
    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final start = today.subtract(
      const Duration(days: 29),
    );

    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    double running = 0;
    int index = 0;

    while (index < sorted.length) {
      final t = sorted[index];

      final tDay = DateTime(
        t.date.year,
        t.date.month,
        t.date.day,
      );

      if (tDay.isBefore(start)) {
        running += t.isIncome ? t.amount : -t.amount;
        index++;
      } else {
        break;
      }
    }

    final balances = <double>[];

    for (int i = 0; i < 30; i++) {
      final day = start.add(Duration(days: i));

      final isToday = day == today;

      while (index < sorted.length) {
        final t = sorted[index];

        final tDay = DateTime(
          t.date.year,
          t.date.month,
          t.date.day,
        );

        if (!isToday && tDay.isAfter(day)) {
          break;
        }

        running += t.isIncome
            ? t.amount
            : -t.amount;

        index++;
      }

      balances.add(running);
    }

    return balances;
  }

  double get monthIncome => monthTransactions
      .where((t) => t.isIncome)
      .fold(
        0,
        (sum, t) => sum + t.amount,
      );

  double get monthExpenses => monthTransactions
      .where((t) => !t.isIncome)
      .fold(
        0,
        (sum, t) => sum + t.amount,
      );

  double get balance => _transactions.fold(
        0,
        (sum, t) =>
            t.isIncome
                ? sum + t.amount
                : sum - t.amount,
      );

  double get monthSavings =>
      monthIncome - monthExpenses;

  bool get isSaving =>
      monthSavings >= 0;

  Future<void> addTransaction(
      Transaction transaction) async {
    final box =
        Hive.box<Transaction>('transactions');

    await box.put(
      transaction.id,
      transaction,
    );

    _transactions.insert(
      0,
      transaction,
    );

    notifyListeners();
  }

  Future<void> removeTransaction(
      String id) async {
    final box =
        Hive.box<Transaction>('transactions');

    await box.delete(id);

    _transactions.removeWhere(
      (t) => t.id == id,
    );

    notifyListeners();
  }

  Future<void> loadTransactions() async {
    final box =
        Hive.box<Transaction>('transactions');

    _transactions.clear();

    _transactions.addAll(
      box.values.toList(),
    );

    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
  await updateCurrency(currency);
}

Future<void> toggleTheme() async {
  await updateTheme(!_isDarkMode);
}

  Future<void> clearAllData() async {
    await Hive.box<Transaction>(
      'transactions',
    ).clear();

    _transactions.clear();

    notifyListeners();
  }
}