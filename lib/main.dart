import 'package:flutter/material.dart';
import 'splash_screen.dart';  // Import the splash screen
// Import your other screens

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Log App',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF4081), // Vibrant pink for primary color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF81D4FA), // Light blue for accents
        ),
        scaffoldBackgroundColor: Colors.transparent, // Make the background transparent for gradient
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const SplashScreen(),  // Start with the splash screen
    );
  }
}

class ImageBackground extends StatelessWidget {
  final Widget child;

  const ImageBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'), // Your background image path here
          fit: BoxFit.cover,  // Make the image cover the screen
        ),
      ),
      child: child,  // Place the child widget over the background
    );
  }
}
