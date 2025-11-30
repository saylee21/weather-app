import 'package:flutter/material.dart';
import 'package:weatherapp/core/constant/image_constants.dart';
import 'weather_page.dart'; // Assuming relative path

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WeatherPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your app icon
              Image.asset(
                ImageConstant.iconSplash, // Adjust to your icon path
                width: 150, // Adjustable size
                height: 150,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Colors.white, // Loading spinner for UX
              ),
            ],
          ),
        ),
      ),
    );
  }
}