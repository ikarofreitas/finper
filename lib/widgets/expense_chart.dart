import 'package:flutter/material.dart';
import 'package:finper_flutter/core/theme/app_colors.dart';

/// Gráfico ilustrativo decorativo (sem lógica de dados reais).
class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  static const _barHeights = [0.45, 0.72, 0.55, 0.88, 0.62, 0.78, 0.50];
  static const _labels = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
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
            children: List.generate(_barHeights.length, (index) {
              final isHighlight = index == 3;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == _barHeights.length - 1 ? 0 : 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: _barHeights[index],
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: isHighlight
                                    ? [
                                        AppColors.primary,
                                        AppColors.primaryLight,
                                      ]
                                    : [
                                        AppColors.primary.withValues(alpha: 0.3),
                                        AppColors.primary.withValues(alpha: 0.15),
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
                          fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
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
