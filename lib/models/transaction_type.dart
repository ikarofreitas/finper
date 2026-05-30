enum TransactionType {
  income,
  expense;

  String get label => switch (this) {
        TransactionType.income => 'Receita',
        TransactionType.expense => 'Despesa',
      };
}
