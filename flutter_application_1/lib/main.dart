import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'timer.dart'; // Import the timer page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(), // Start with HomePage
      routes: {
        '/login': (context) => const LoginPage(), // Route to LoginPage
        '/timer': (context) => const TimerPage(), // Route to TimerPage
      },
    );
  }
}




// stop/resume button
// home page, login