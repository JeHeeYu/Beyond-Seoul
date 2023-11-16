import 'package:beyond_seoul/routes/routes_name.dart';
import 'package:beyond_seoul/view/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeScreen:
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen());
    }
  }
}
