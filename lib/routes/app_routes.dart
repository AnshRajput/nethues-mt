import 'package:get/get.dart';
import '../pages/home_page.dart';
import '../pages/scanner_page.dart';
import '../pages/dashboard_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String scanner = '/scanner';
  static const String dashboard = '/dashboard';

  static List<GetPage> routes = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: scanner, page: () => const ScannerPage()),
    GetPage(name: dashboard, page: () => const DashboardPage()),
  ];
}
