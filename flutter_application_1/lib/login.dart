import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'timer.dart';
import 'register.dart';
import 'home.dart';
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
      body: Stack(
        children: [
          // Add the rain background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 8, 51, 63),
                  Color.fromARGB(255, 21, 236, 229),
                ],
              ),
            ),
            child: ParallaxRain(
              dropColors: [
                Colors.purple,
                Colors.teal,
                Colors.blue,
                Colors.indigo,
              ],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
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
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.home,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}