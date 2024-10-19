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
  bool _isPasswordVisible = false; // Track the visibility of the password

  Future<void> _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      const String apiUrl = 'https://sleep.solarwolf.xyz/login';

      try {
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'username': username,
            'password': password,
          }),
        );

        if (!mounted) return;

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
                  RouteSettings(arguments: {'username': loggedInUsername}),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid username or password')),
          );
        }
      } catch (error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error logging in. Please try again later.')),
        );
      }
    } else {
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
                        decoration: InputDecoration(
                          labelText: 'Username',
                          fillColor: Colors.grey[300], // Light gray background
                          filled: true, // Apply background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.grey[600]!, // Darker gray border
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: const Icon(
                              Icons.person), // Silhouette icon for username
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          fillColor: Colors.grey[300], // Light gray background
                          filled: true, // Apply background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.grey[600]!, // Darker gray border
                              width: 2.0,
                            ),
                          ),
                          prefixIcon:
                              const Icon(Icons.lock), // Key icon for password
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Toggle visibility based on _isPasswordVisible
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText:
                            !_isPasswordVisible, // Toggle password visibility
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text(
                            'Don\'t have an account? Register',
                            style: TextStyle(color: Colors.black), // Black text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
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
