import 'package:flutter/material.dart';
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0xFF1D4ED8),
          secondary: const Color(0xFF6625AC),
        ),
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