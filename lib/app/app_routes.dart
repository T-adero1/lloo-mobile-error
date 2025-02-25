import 'package:get/get.dart';
import 'debug/debug.dart';

/// class for gathering the roots from various models.
///
/// The aim here is to reduce top-level dependency on the modules
/// as much as possible.
///
/// Modules use the global instance and add their routes for the app
/// loader in main.dart
class AppRoutes {
  // Initial view to show. Handle debugging interception
  late String _initialRoute; // be sure to set this in main before runApp
  String get initialRoute => kDebugForceStartupRoute ?? _initialRoute;
  set initialRoute(String route) => _initialRoute = route;

  static final AppRoutes _instance = AppRoutes._internal();

  factory AppRoutes() { return _instance; }

  List<GetPage> get routes => _routes;
  AppRoutes._internal();

  final List<GetPage> _routes = [];

  void registerRoutes(List<GetPage> pages) {
    _routes.addAll(pages);
  }
}

/// @TODO: Change this to use Getx and have a static getter on AppRoutes maybe
final $appRoutes = AppRoutes();
