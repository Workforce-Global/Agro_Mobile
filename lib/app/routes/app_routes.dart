// app_routes.dart
// TODO: Define app routes
import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/welcome/welcome_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const signup = '/signup';
  static const login = '/login';
  static const welcome = '/welcome';
  static const dashboard = '/dashboard';

  static final routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: welcome, page: () => WelcomeScreen()),
    GetPage(name: dashboard, page: () => DashboardScreen()),
  ];
}
