import 'package:flutter/material.dart';
import 'package:movies/authentication/register/register_screen.dart';
import 'package:movies/core/routes_manager/routes.dart';
import 'package:movies/features/main_layout/browse_tab/browse_tab.dart';
import 'package:movies/features/main_layout/main_layout.dart';
import 'package:movies/features/main_layout/profile_tab/profile_screen.dart';
import 'package:movies/features/movie_details_screen/movie_details_screen.dart';
import 'package:movies/onboarding_screen/onboarding_screen.dart';
import 'package:movies/authentication/login/login_screen.dart';
import 'package:movies/authentication/login/forget_password_screen.dart';
import 'package:movies/profile/update_profile_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      case Routes.movieDetailsRoute:
        final movieId = settings.arguments as num;
        return MaterialPageRoute(
          builder: (_) => MovieDetailsScreen(movieID: movieId),
        );

      case Routes.browseRoute:
        final args = settings.arguments as Map<String, dynamic>;

        final genreIndex = args["genreIndex"] as int;
        final genres = args["genres"] as List<dynamic>?;

        return MaterialPageRoute(
          builder: (_) => BrowseTab(genreIndex: genreIndex, genres: genres,),
        );
      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (_)=> const OnBoardingScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.forgetPasswordRoute:
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case Routes.updateProfileRoute:
        return MaterialPageRoute(builder: (_) => const UpdateProfileScreen());
      case Routes.profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
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