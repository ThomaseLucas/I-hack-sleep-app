import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: const HomePage(), // Start with HomePage
      routes: {
        '/login': (context) => const LoginPage(), // Route to LoginPage
      },
    );
  }
}




// stop/resume button
// home page, login