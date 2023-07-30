import 'package:flutter/material.dart';
import 'package:units_reflection/Pages/login.dart';
import 'package:units_reflection/Pages/register.dart';
import 'package:units_reflection/Pages/unit_reflection.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String reflectionPage = '/reflectionPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );

      case reflectionPage:
        return MaterialPageRoute(
          builder: (context) => UnitReflectionPage(),
        );

      default:
        throw FormatException('Route not found! Check routes again!');
    }
  }
}
