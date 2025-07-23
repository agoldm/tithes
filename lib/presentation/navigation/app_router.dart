import 'package:flutter/material.dart';
import 'package:tithes/presentation/pages/home_page.dart';
import 'package:tithes/presentation/pages/income_page.dart';
import 'package:tithes/presentation/pages/donations_page.dart';

class AppRouter {
  static const String home = '/';
  static const String income = '/income';
  static const String donations = '/donations';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case income:
        return MaterialPageRoute(builder: (_) => const IncomePage());
      case donations:
        return MaterialPageRoute(builder: (_) => const DonationsPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}