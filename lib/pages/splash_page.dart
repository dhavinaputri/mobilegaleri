import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_guest_page.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    
    // Check if user has logged in before
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (!mounted) return;
    
    if (isLoggedIn) {
      // If user was logged in, go to home page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    } else {
      // If not logged in, go to login/guest page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginGuestPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ganti dengan logo atau splash screen Anda
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text(
              'GaleriKu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
