import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'timer.dart';
import 'register.dart';
import 'package:parallax_rain/parallax_rain.dart'; // Import the ParallaxRain package

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    // Debug statement to check input values
    print("DEBUG: Username: $username, Password: $password");

    if (username.isNotEmpty && password.isNotEmpty) {
      print("Attempting to log in...");
      const String apiUrl = 'http://10.244.30.167:5000/login';

      try {
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': username,
            'password': password,
          }),
        );
        print("Response Status: ${response.statusCode}");

        // Debug statement to check response status code and body
        print("DEBUG: Response Status: ${response.statusCode}");
        print("DEBUG: Response Body: ${response.body}");

        // Check if the widget is still mounted after async operation
        if (!mounted) return;

        // Check for successful response (status code 200)
        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          String loggedInUsername = responseBody['username'];

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const TimerPage(),
                settings:
                    RouteSettings(arguments: {'username': loggedInUsername})),
          );
        } else {
          // Show error if login fails
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
          );
        }
      } catch (error) {
        // Debug statement to log any errors
        print("DEBUG: Error logging in: $error");

        // Check if the widget is still mounted after async operation
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error logging in. Please try again later.')),
        );
      }
    } else {
      print("Missing username or password.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Stack(
        children: [
          _buildRainBackground(), // Add rain background
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white, // Background color for text field
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white, // Background color for text field
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRainBackground() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ParallaxRain(
        dropColors: [
          const Color(0xFFBF77F6), // Matching with AppBar color
          const Color(0xFF21ECE5), // Matching with gradient colors
          const Color(0xFF8D8D8D), // Neutral gray for variety
          const Color(0xFFFFFFFF), // White for a brighter effect
        ],
      ),
    );
  }
}
