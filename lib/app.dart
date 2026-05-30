import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finper_flutter/core/theme/app_theme.dart';
import 'package:finper_flutter/providers/finance_provider.dart';
import 'package:finper_flutter/screens/main_shell.dart';

class FinPerApp extends StatelessWidget {
  const FinPerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinanceProvider(),
      child: Consumer<FinanceProvider>(
        builder: (context, finance, _) {
          return MaterialApp(
            title: 'FinPer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: finance.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainShell(),
          );
        },
      ),
    );
  }
}
