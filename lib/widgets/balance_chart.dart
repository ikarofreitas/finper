import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:finper_flutter/core/theme/app_colors.dart';
import 'package:finper_flutter/core/utils/currency_formatter.dart';
import 'package:finper_flutter/providers/finance_provider.dart';

class BalanceChart extends StatelessWidget {
  const BalanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final balances = finance.last30DaysBalance;

    if (finance.transactions.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.show_chart_rounded,
                size: 40,
                color: AppColors.textTertiary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Adicione transações para\nver a evolução do saldo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final spots = <FlSpot>[
      for (var i = 0; i < balances.length; i++)
        FlSpot(i.toDouble(), balances[i]),
    ];

    final minBalance = balances.reduce((a, b) => a < b ? a : b);
    final maxBalance = balances.reduce((a, b) => a > b ? a : b);
    final range = (maxBalance - minBalance).abs();
    final padding = range == 0 ? (maxBalance.abs() * 0.1).clamp(50.0, 500.0) : range * 0.15;

    final minY = minBalance - padding;
    final maxY = maxBalance + padding;
    final isPositive = balances.last >= 0;
    final lineColor = isPositive ? AppColors.primary : AppColors.expense;

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 29));
    final currency = finance.currency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Evolução do saldo',
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
                color: isPositive
                    ? AppColors.primarySurface
                    : AppColors.expenseLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '30 dias',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isPositive
                      ? AppColors.primaryDark
                      : AppColors.expense,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          CurrencyFormatter.format(balances.last, currency: currency),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: lineColor,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (balances.length - 1).toDouble(),
              minY: minY,
              maxY: maxY,
              clipData: const FlClipData.all(),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: (maxY - minY) / 4,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : AppColors.border.withValues(alpha: 0.8),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    interval: (maxY - minY) / 4,
                    getTitlesWidget: (value, meta) {
                      if (value == meta.min || value == meta.max) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          _compactCurrency(value, currency),
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 7,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 || index >= balances.length) {
                        return const SizedBox.shrink();
                      }
                      // Mostra início, meio e fim
                      if (index != 0 &&
                          index != 14 &&
                          index != balances.length - 1) {
                        return const SizedBox.shrink();
                      }
                      final date = start.add(Duration(days: index));
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          DateFormat('dd/MM').format(date),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textTertiary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => isDark
                      ? AppColors.darkSurface
                      : AppColors.textPrimary,
                  tooltipBorderRadius: BorderRadius.circular(10),
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final date = start.add(Duration(days: spot.x.round()));
                      return LineTooltipItem(
                        '${DateFormat('dd/MM').format(date)}\n'
                        '${CurrencyFormatter.format(spot.y, currency: currency)}',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.25,
                  barWidth: 3,
                  color: lineColor,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    checkToShowDot: (spot, _) =>
                        spot.x == 0 || spot.x == spots.length - 1,
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: lineColor,
                        strokeWidth: 2,
                        strokeColor: isDark
                            ? AppColors.darkSurface
                            : Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        lineColor.withValues(alpha: 0.25),
                        lineColor.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _compactCurrency(double value, String currency) {
    final symbol = switch (currency) {
      'USD' => r'$',
      'EUR' => '€',
      _ => r'R$',
    };
    final abs = value.abs();
    if (abs >= 1000000) {
      return '$symbol${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (abs >= 1000) {
      return '$symbol${(value / 1000).toStringAsFixed(1)}k';
    }
    return '$symbol${value.toStringAsFixed(0)}';
  }
}
