import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/flavor_config.dart';

/// Run with: flutter run -t lib/main_prod.dart
/// Points at the live API and turns off the verbose Dio request
/// logging that DioClient only enables in FlavorConfig.isDev.
void main() {
  FlavorConfig(
    flavor: Flavor.prod,
    baseUrl: 'https://api.matricconnect.app',
    appTitle: 'MatricConnect',
  );

  runApp(const ProviderScope(child: MatricConnectApp()));
}
