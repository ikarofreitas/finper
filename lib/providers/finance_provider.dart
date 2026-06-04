import 'package:flutter/foundation.dart';
import 'package:finper_flutter/models/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FinanceProvider extends ChangeNotifier {
  FinanceProvider() {
    loadTransactions();
    loadUserName();
  } // Inicia vazio, as transações são adicionadas posteriormente

  final List<Transaction> _transactions = [];
  bool _isDarkMode = false;
  String _userName = 'Usuário';
  String _currency = 'BRL';

  List<Transaction> get transactions => List.unmodifiable(_transactions);

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

  // Adicionar transação
  Future<void> addTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>('transactions');

    await box.put(transaction.id, transaction);

    _transactions.insert(0, transaction);

    notifyListeners();
  }

  // Remover transação
  Future<void> removeTransaction(String id) async {
    final box = Hive.box<Transaction>('transactions');

    await box.delete(id);

    _transactions.removeWhere((t) => t.id == id);

    notifyListeners();
  }

  // Salvar nome do usuário
  Future<void> saveUserName(String name) async {
    final box = Hive.box('settings');

    await box.put('userName', name);

    notifyListeners();
  }

  // Carregar nome do usuário
  Future<void> loadUserName() async {
    final box = Hive.box('settings');

    _userName = box.get('userName', defaultValue: 'Usuário');

    notifyListeners();
  }

  // Carregar transações
  Future<void> loadTransactions() async {
    final box = Hive.box<Transaction>('transactions');

    _transactions.clear();

    _transactions.addAll(box.values.toList());

    notifyListeners();
  }

  // Alternar tema
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }
}
