import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/finance_provider.dart';
import '../../widgets/transaction_tile.dart';

import 'package:intl/intl.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();

    final transactions = List.of(finance.transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    final grouped = <String, List<dynamic>>{};

    for (final transaction in transactions) {
      final key = DateFormat('MMMM yyyy', 'pt_BR').format(transaction.date);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(transaction);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Todas as transações")),
      body: transactions.isEmpty
          ? const Center(child: Text("Nenhuma transação"))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 12),
                      child: Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ...entry.value.map(
                      (transaction) =>
                          TransactionTile(transaction: transaction),
                    ),
                  ],
                );
              }).toList(),
            ),
    );
  }
}
