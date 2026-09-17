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
      return 'ca-app-pub-9097047281588244/5999681493';
    }

    throw UnsupportedError('Plataforma não suportada');
  }
}