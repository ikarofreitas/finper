import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (kDebugMode) {
      //  Desenvolvimento
      return 'ca-app-pub-3940256099942544/6300978111';
    }

    if (Platform.isAndroid) {
      // Produção
      return 'ca-app-pub-9524621548436380/6356051553';
    }

    throw UnsupportedError('Plataforma não suportada');
  }
}