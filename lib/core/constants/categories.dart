import 'package:flutter/material.dart';
import 'package:finper_flutter/models/transaction_type.dart';

class CategoryItem {
  const CategoryItem({
    required this.name,
    required this.icon,
    this.types = const [TransactionType.expense, TransactionType.income],
  });

  final String name;
  final IconData icon;
  final List<TransactionType> types;
}

abstract final class AppCategories {
  static const List<CategoryItem> all = [
    CategoryItem(
      name: 'Alimentação',
      icon: Icons.restaurant_rounded,
      types: [TransactionType.expense],
    ),
    CategoryItem(
      name: 'Transporte',
      icon: Icons.directions_car_rounded,
      types: [TransactionType.expense],
    ),
    CategoryItem(
      name: 'Saúde',
      icon: Icons.favorite_rounded,
      types: [TransactionType.expense],
    ),
    CategoryItem(
      name: 'Lazer',
      icon: Icons.sports_esports_rounded,
      types: [TransactionType.expense],
    ),
    CategoryItem(
      name: 'Educação',
      icon: Icons.school_rounded,
      types: [TransactionType.expense],
    ),
    CategoryItem(
      name: 'Salário',
      icon: Icons.work_rounded,
      types: [TransactionType.income],
    ),
    CategoryItem(
      name: 'Investimentos',
      icon: Icons.trending_up_rounded,
      types: [TransactionType.income, TransactionType.expense],
    ),
    CategoryItem(
      name: 'Outros',
      icon: Icons.more_horiz_rounded,
      types: [TransactionType.income, TransactionType.expense],
    ),
  ];

  static List<CategoryItem> forType(TransactionType type) {
    return all.where((c) => c.types.contains(type)).toList();
  }

  static IconData iconFor(String name) {
    return all
        .firstWhere(
          (c) => c.name == name,
          orElse: () => const CategoryItem(
            name: 'Outros',
            icon: Icons.more_horiz_rounded,
          ),
        )
        .icon;
  }
}
