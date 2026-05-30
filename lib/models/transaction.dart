import 'package:finper_flutter/models/transaction_type.dart';

class Transaction {
  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });

  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final String category;
  final DateTime date;

  bool get isIncome => type == TransactionType.income;
}
