import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/splash_page.dart';
import 'pages/login_guest_page.dart';
import 'pages/home_page.dart';
import 'pages/onboarding_page.dart';
import 'pages/welcome_auth_page.dart';
import 'routes.dart' as app_routes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduSpot',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Tailwind blue-600
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF2563EB), // blue-600
          secondary: const Color(0xFF7C3AED), // violet-600 accent
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginGuestPage(),
        '/home': (context) => const HomePage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/welcome': (context) => const WelcomeAuthPage(),
      },
      onGenerateRoute: app_routes.onGenerateRoute,
    );
  }
}