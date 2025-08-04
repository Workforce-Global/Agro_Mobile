// app_routes.dart
// TODO: Define app routes
import 'package:agro_sav/app/screens/dashboard/crop%20analysis/crop_analysis_dashboard.dart';
import 'package:agro_sav/app/screens/dashboard/history/history_screen.dart';
import 'package:agro_sav/app/screens/dashboard/mobile%20dash/mobile_dash_screen.dart';
import 'package:agro_sav/app/screens/permissions/permissions_screen.dart';
import 'package:get/get.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/welcome/welcome_screen.dart';


class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const signup = '/signup';
  static const login = '/login';
  static const welcome = '/welcome';
  static const dashboard = '/dashboard';
  static const mobiledash = '/mobiledash';
  static const permissions = '/permissions';
  static const cropAnalysis = '/crop-analysis';
  static const history = '/history';

  static final routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: signup, page: () => SignUpScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: welcome, page: () => WelcomeScreen()),
    GetPage(name: mobiledash, page: () => MobileDashboardScreen()),
        GetPage(name: permissions, page: () => const PermissionScreen()),
        GetPage(name: cropAnalysis, page: () => const CropAnalysisDashboard()),
    GetPage(name: history, page: () => const HistoryScreen()),
      ];
    }