import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:finper_flutter/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:finper_flutter/models/transaction.dart';
import 'package:finper_flutter/models/transaction_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  await Hive.initFlutter();
  await MobileAds.instance.initialize();
  
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());

  
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox('settings');

  await Hive.box<Transaction>('transactions').clear();
  await Hive.box('settings').clear();
 

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const FinPerApp());
}
