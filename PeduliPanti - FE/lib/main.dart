import 'package:flutter/material.dart';
import 'onboarding1.dart'; // Import file onboarding1.dart

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false, // Hilangkan banner debug
    home:
        const Onboarding1App(), // Panggil kelas OnboardingApp dari onboarding1.dart
  ));
}
