import 'package:flutter/material.dart';
import 'package:parallax_rain/parallax_rain.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 8, 51, 63),
              Color.fromARGB(255, 21, 236, 229)
            ],
          ),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ParallaxRain(
            dropColors: [
              const Color(0xFFBF77F6), // Matching with AppBar color
              const Color(0xFF21ECE5), // Matching with gradient colors
              const Color(0xFF8D8D8D), // Neutral gray for variety
              const Color(0xFFffffff), // White for a brighter effect
            ],
            child: Center(
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/waving_frog.png', // Add your sleep-related image
                        height: 100,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome to Rest Assured!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFBF77F6), // Set text color
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFFBF77F6), // Button background color
                          foregroundColor: Colors.white, // Button text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/login'); // Navigate to LoginPage
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
