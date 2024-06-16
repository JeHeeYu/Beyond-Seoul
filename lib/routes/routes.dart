import 'package:beyond_seoul/routes/routes_name.dart';
import 'package:beyond_seoul/view/screens/home_screen.dart';
import 'package:beyond_seoul/view/screens/onboarding/onboarding_screen.dart';
import 'package:beyond_seoul/view/screens/login_screen.dart';
import 'package:beyond_seoul/view/screens/splash_screen.dart';
import 'package:beyond_seoul/view/screens/error_screen.dart';
import 'package:beyond_seoul/view/screens/leader_code_screen.dart';
import 'package:flutter/material.dart';
import '../app.dart';
import '../view/screens/mate_code_screen.dart';
import '../view/screens/record_feed_screen.dart';
import 'page_router.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.app:
        return PageRouter(builder: (BuildContext context) => const App());
      case RoutesName.onboarding:
        return PageRouter(builder: (BuildContext context) => const OnboardingScreen());
      case RoutesName.login:
        return PageRouter(builder: (BuildContext context) => const LoginScreen());
      case RoutesName.splash:
        return PageRouter(builder: (BuildContext context) => const SplashScreen());
      case RoutesName.error:
        return PageRouter(builder: (BuildContext context) => const ErrorScreen());
      case RoutesName.leaderCode:
        return PageRouter(builder: (BuildContext context) => const LeaderCodeScreen());
      case RoutesName.mateCode:
        return PageRouter(builder: (BuildContext context) => const MateReCodeScreen());
      default:
        return PageRouter(builder: (BuildContext context) => const App());
    }
  }
}
