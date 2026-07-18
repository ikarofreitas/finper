import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finper_flutter/core/theme/app_colors.dart';
import 'package:finper_flutter/providers/finance_provider.dart';
import 'package:finper_flutter/widgets/app_card.dart';
import 'package:finper_flutter/widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Finper'),
          ],
        ),
        content: const Text(
          'Finper é um aplicativo de gestão de finanças pessoais. '
          'Controle suas receitas e despesas de forma simples e elegante.\n\n'
          'Versão 1.0.0',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Política de Privacidade'),
        content: const SingleChildScrollView(
          child: Text(
            'O Finper armazena todos os dados localmente no seu dispositivo. '
            'Nenhuma informação é enviada para servidores externos.\n\n'
            'Este é um aplicativo demonstrativo sem backend. '
            'Seus dados financeiros permanecem apenas na memória do app '
            'durante a sessão atual. \n'
            'Você pode saber mais em: \n'
            'https://finpertermsconditions.netlify.app',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, FinanceProvider finance) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        const currencies = [
          ('BRL', 'Real Brasileiro', 'R\$'),
          ('USD', 'Dólar Americano', '\$'),
          ('EUR', 'Euro', '€'),
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Moeda utilizada',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...currencies.map((item) {
                  final (code, name, symbol) = item;
                  final isSelected = finance.currency == code;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? AppColors.primarySurface
                          : AppColors.divider,
                      child: Text(
                        symbol,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    title: Text(name),
                    subtitle: Text(code),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () {
                      finance.setCurrency(code);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final finance = context.watch<FinanceProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        finance.userName.isNotEmpty
                            ? finance.userName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          finance.userName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Conta gratuita',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Preferências',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Tema escuro',
                    subtitle: finance.isDarkMode ? 'Ativado' : 'Desativado',
                    showDivider: true,
                    trailing: Switch.adaptive(
                      value: finance.isDarkMode,
                      onChanged: (_) => finance.toggleTheme(),
                      activeTrackColor: AppColors.primary,
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notificações (em desenvolvimento)',
                    subtitle: 'Lembretes de gastos',
                    onTap: () {},
                  ),
                  SettingsTile(
                    icon: Icons.attach_money_rounded,
                    title: 'Moeda utilizada',
                    subtitle: finance.currency == 'BRL'
                        ? 'Real Brasileiro (R\$)'
                        : finance.currency == 'USD'
                        ? 'Dólar Americano (\$)'
                        : 'Euro (€)',
                    onTap: () => _showCurrencyDialog(context, finance),
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sobre',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Sobre o aplicativo',
                    onTap: () => _showAboutDialog(context),
                  ),
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Política de privacidade',
                    onTap: () => _showPrivacyDialog(context),
                    iconColor: AppColors.textSecondary,
                  ),
                  SettingsTile(
                    icon: Icons.verified_outlined,
                    title: 'Versão do app',
                    subtitle: '1.0.0',
                    showDivider: false,
                    trailing: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Finper © 2026',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
