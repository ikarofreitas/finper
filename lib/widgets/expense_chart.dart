import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/finance_provider.dart';
import '../models/transaction_type.dart';
import '../core/theme/app_colors.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();

    final transactions = List.of(finance.transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    double runningBalance = 0;

    final spots = <FlSpot>[];

    for (int i = 0; i < transactions.length; i++) {
      final transaction = transactions[i];

      if (transaction.type == TransactionType.income) {
        runningBalance += transaction.amount;
      } else {
        runningBalance -= transaction.amount;
      }

      spots.add(
        FlSpot(
          i.toDouble(),
          runningBalance,
        ),
      );
    }

    if (spots.isEmpty) {
      spots.add(const FlSpot(0, 0));
    }
    if (finance.transactions.isEmpty) {
  return const SizedBox(
    height: 220,
    child: Center(
      child: Text(
        'Adicione transações para visualizar a evolução do saldo',
      ),
    ),
  );
}
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),

          borderData: FlBorderData(show: false),

          titlesData: const FlTitlesData(
            rightTitles: AxisTitles(),
            topTitles: AxisTitles(),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 4,

              color: AppColors.primary,

              dotData: const FlDotData(
                show: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}