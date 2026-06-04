import 'package:hive/hive.dart';
import 'transaction_type.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final TransactionType type;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });

  bool get isIncome => type == TransactionType.income;

  
}

extension TransactionTypeExtension on TransactionType {

  String get label {
    switch (this) {
      case TransactionType.income:
        return 'Receita';

      case TransactionType.expense:
        return 'Despesa';
    }
  }
}