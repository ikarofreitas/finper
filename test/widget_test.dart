import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:finper_flutter/app.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR', null);
  });

  testWidgets('App inicia com tela Home', (WidgetTester tester) async {
    await tester.pumpWidget(const FinPerApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Saldo atual'), findsOneWidget);
  });
}
