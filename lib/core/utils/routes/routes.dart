import 'package:TourEase/core/utils/routes/routes_name.dart';
import 'package:TourEase/views/auth/home_auth_screen.dart';
import 'package:TourEase/views/auth/signup/signup_screen.dart';
import 'package:TourEase/views/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

import 'package:TourEase/views/auth/login/login_screen.dart';
import 'package:TourEase/views/home/home/home_screen.dart';

/// A class that handles generating routes for the app.
///
/// This class uses the MaterialPageRoute to generate routes for the app.
/// It checks the name of the route and returns the corresponding screen.
/// If no route is defined, it returns a default screen with a message.
class Routes {
  /// Generates a route based on the given RouteSettings.
  ///.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final arguments = settings.arguments;

    // Check the name of the route
    switch (settings.name) {
      // If the route is for the splash screen, return a MaterialPageRoute with the SplashScreen as the builder
      case RoutesName.onboarding:
        return MaterialPageRoute(
            builder: (context) => const OnboardingScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RoutesName.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case RoutesName.register:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      case RoutesName.home:
        return MaterialPageRoute(builder: (context) => const HomeAuthScreen());

      // If no route is defined, return a MaterialPageRoute with a default screen
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
