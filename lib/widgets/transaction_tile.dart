import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finper_flutter/core/constants/categories.dart';
import 'package:finper_flutter/core/theme/app_colors.dart';
import 'package:finper_flutter/core/utils/currency_formatter.dart';
import 'package:finper_flutter/core/utils/date_formatter.dart';
import 'package:finper_flutter/models/transaction.dart';
import 'package:finper_flutter/providers/finance_provider.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
Widget build(BuildContext context) {
  final finance = context.watch<FinanceProvider>();
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final isIncome = transaction.isIncome;
  final color = isIncome ? AppColors.income : AppColors.expense;

  final bgColor = isIncome
      ? AppColors.primarySurface
      : (isDark
          ? AppColors.expense.withValues(alpha: 0.15)
          : AppColors.expenseLight);

  return Dismissible(
    key: ValueKey(transaction.id),
    direction: DismissDirection.endToStart,

    background: Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
        size: 28,
      ),
    ),

    confirmDismiss: (_) async {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Excluir transação"),
            content: const Text(
              "Deseja realmente excluir esta transação?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text("Cancelar"),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: const Text("Excluir"),
              ),
            ],
          );
        },
      );

      return result ?? false;
    },

    onDismissed: (_) async {
      await finance.removeTransaction(transaction.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Transação excluída."),
        ),
      );
    },

    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              AppCategories.iconFor(transaction.category),
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${transaction.category} · ${DateFormatter.transactionDate(transaction.date)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount, currency: finance.currency)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}
}
