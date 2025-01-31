import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme, // Light theme
      darkTheme: darkTheme, // Dark theme
      themeMode: ThemeMode.system, // Use system theme
      home: const SplashScreen(),
    );
  }
}
