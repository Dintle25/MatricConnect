import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/flavor_config.dart';

/// Run with: flutter run -t lib/main_dev.dart
/// Points at the dev API, shows request logs in the console, and
/// labels the app "(Dev)" in the title bar/app switcher so nobody
/// mixes it up with the real build during testing.
void main() {
  FlavorConfig(
    flavor: Flavor.dev,
    baseUrl: 'https://dev-api.matricconnect.app',
    appTitle: 'MatricConnect (Dev)',
  );

  runApp(const ProviderScope(child: MatricConnectApp()));
}
