import 'package:flutter/material.dart';
import 'package:movies/auth/register_screen.dart';
import 'package:movies/core/routes_manager/routes.dart';
import 'package:movies/features/main_layout/main_layout.dart';
import 'package:movies/onboarding_screen/onboarding_screen.dart';
import 'package:movies/auth/login_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainLayout());
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_)=> const OnBoardingScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}