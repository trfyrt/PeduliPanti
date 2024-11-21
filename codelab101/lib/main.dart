import 'package:flutter/material.dart';
import 'onboard.dart'; // Import the OnboardingScreen from onboard.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 254, 254, 254), // Light gray background
      ),
      home: const OnboardingScreen(), // Set OnboardingScreen as the home
    );
  }
}
