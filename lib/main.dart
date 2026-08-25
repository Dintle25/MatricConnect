import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/flavor_config.dart';

/// Plain entry point for `flutter run` with no flavor picked — this
/// just points at the dev API so the app still opens normally from
/// an IDE's green play button. For the real flavor split, use
/// main_dev.dart or main_prod.dart instead.
void main() {
  FlavorConfig(
    flavor: Flavor.dev,
    baseUrl: 'https://dev-api.matricconnect.app',
    appTitle: 'MatricConnect (Dev)',
  );

  runApp(const ProviderScope(child: MatricConnectApp()));
}
