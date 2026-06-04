import 'package:flutter/material.dart';
import 'package:finper_flutter/core/theme/app_colors.dart';
import 'package:finper_flutter/providers/finance_provider.dart';
import 'package:provider/provider.dart';
import 'package:finper_flutter/models/transaction_type.dart';

/// Gráfico ilustrativo decorativo (sem lógica de dados reais).
class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  static const _labels = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final finance = context.watch<FinanceProvider>();

    final expenses = finance.transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();
    final now = DateTime.now();

    final dailyExpenses = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));

      final total = expenses
          .where(
            (t) =>
                t.date.year == day.year &&
                t.date.month == day.month &&
                t.date.day == day.day,
          )
          .fold<double>(0, (sum, t) => sum + t.amount);

      return total;
    });

    final maxValue = dailyExpenses.isEmpty
        ? 1.0
        : dailyExpenses.reduce((a, b) => a > b ? a : b);

    final barHeights = dailyExpenses.map((value) {
      if (maxValue == 0) {
        return 0.0;
      }

      return value / maxValue;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Visão semanal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Este mês',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(barHeights.length, (index) {
              final isHighlight = index == 3;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == barHeights.length - 1 ? 0 : 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: barHeights[index],
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: isHighlight
                                    ? [
                                        AppColors.expense,
                                        AppColors.expenseLight,
                                      ]
                                    : [
                                        AppColors.expense.withValues(
                                          alpha: 0.3,
                                        ),
                                        AppColors.expense.withValues(
                                          alpha: 0.15,
                                        ),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _labels[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isHighlight
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isHighlight
                              ? AppColors.primary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
