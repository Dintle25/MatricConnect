/// Which environment the app was built for. We read this once at
/// startup from main_dev.dart / main_prod.dart and never change it
/// again while the app is running.
enum Flavor { dev, prod }

/// Simple singleton so any file can ask "what environment am I in?"
/// without passing a value down through ten constructors.
class FlavorConfig {
  final Flavor flavor;
  final String baseUrl;
  final String appTitle;

  static FlavorConfig? _instance;

  FlavorConfig._({
    required this.flavor,
    required this.baseUrl,
    required this.appTitle,
  });

  factory FlavorConfig({
    required Flavor flavor,
    required String baseUrl,
    required String appTitle,
  }) {
    _instance ??= FlavorConfig._(flavor: flavor, baseUrl: baseUrl, appTitle: appTitle);
    return _instance!;
  }

  static FlavorConfig get instance {
    if (_instance == null) {
      throw StateError('FlavorConfig was never initialised. Run main_dev.dart or main_prod.dart.');
    }
    return _instance!;
  }

  static bool get isDev => instance.flavor == Flavor.dev;
  static bool get isProd => instance.flavor == Flavor.prod;
}
