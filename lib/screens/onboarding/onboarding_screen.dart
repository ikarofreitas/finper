import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/finance_provider.dart';
import '../main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final TextEditingController _nameController = TextEditingController();

  int _currentPage = 0;

  String _currency = 'BRL';

  bool _isDark = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final finance = context.read<FinanceProvider>();

    await finance.saveSettings(
      userName: _nameController.text.trim(),
      currency: _currency,
      isDarkMode: _isDark,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.green
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,

                physics: const NeverScrollableScrollPhysics(),

                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },

                children: [
                  _welcomePage(),

                  _namePage(),

                  _currencyPage(),

                  _themePage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _welcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Image.asset('assets/icon/icon.png', width: 120, height: 120),

          const SizedBox(height: 40),

          const Text(
            "Bem-vindo ao FinPer",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          const Text(
            "Vamos configurar seu aplicativo em menos de um minuto.",
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 50),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: _nextPage,

              child: const Text("Começar"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _namePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Como podemos te chamar?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          const Text(
            "Esse nome será usado para personalizar sua experiência.",
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 40),

          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: "Seu nome",
              hintText: "Ex: João",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Digite seu nome para continuar"),
                    ),
                  );
                  return;
                }

                _nextPage();
              },
              child: const Text("Continuar"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _currencyPage() {
    final currencies = [
      {"code": "BRL", "name": "Real brasileiro", "icon": "🇧🇷"},
      {"code": "USD", "name": "Dólar americano", "icon": "🇺🇸"},
      {"code": "EUR", "name": "Euro", "icon": "🇪🇺"},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Qual moeda você utiliza?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40),

          ...currencies.map((currency) {
            final selected = _currency == currency["code"];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _currency = currency["code"]!;
                });
              },

              child: Container(
                margin: const EdgeInsets.only(bottom: 16),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(
                    width: 2,
                    color: selected ? Colors.green : Colors.grey.shade300,
                  ),
                ),

                child: Row(
                  children: [
                    Text(
                      currency["icon"]!,
                      style: const TextStyle(fontSize: 32),
                    ),

                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currency["name"]!,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(currency["code"]!),
                      ],
                    ),

                    const Spacer(),

                    if (selected)
                      const Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextPage,
              child: const Text("Continuar"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themePage() {
    return Padding(
      padding: const EdgeInsets.all(24),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Escolha seu tema",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40),

          _themeCard(
            title: "Claro",
            subtitle: "Interface clara",
            icon: Icons.light_mode,
            value: false,
          ),

          const SizedBox(height: 16),

          _themeCard(
            title: "Escuro",
            subtitle: "Interface escura",
            icon: Icons.dark_mode,
            value: true,
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: _finish,

              child: const Text("Entrar no FinPer"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
  }) {
    final selected = _isDark == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isDark = value;
        });
      },

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            width: 2,
            color: selected ? Colors.green : Colors.grey.shade300,
          ),
        ),

        child: Row(
          children: [
            Icon(icon, size: 32),

            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(subtitle),
              ],
            ),

            const Spacer(),

            if (selected) const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
