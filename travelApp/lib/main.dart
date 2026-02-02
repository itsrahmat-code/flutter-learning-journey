import 'package:flutter/material.dart';
import 'package:travelapp/onboarding/onboarding_screen.dart';
import 'package:travelapp/screens/home_screen.dart';
import 'package:travelapp/screens/welcome_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Alarm App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
      // Set initial route to Onboarding
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/homescreen': (context) => const HomeScreen(),
      },
    );
  }
}