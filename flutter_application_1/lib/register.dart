import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home.dart';
import 'package:parallax_rain/parallax_rain.dart'; // Import the ParallaxRain package

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Track the visibility of the password

  Future<void> _register(BuildContext context) async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    // Check if any fields are empty
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    const String apiUrl = "https://sleep.solarwolf.xyz/register";

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'username': username, 'email': email, 'password': password}),
      );

      if (!mounted) return; // Ensure the widget is still mounted

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error registering. Please try again later')),
        );
      }
    } catch (error) {
      if (!mounted) return; // Ensure the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Error registering. Please try again later.')));
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
                    children: [
                      TextField(
                        controller: _usernameController,
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
                          prefixIcon:
                              const Icon(Icons.person), // Icon for username
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.grey[300], // Light gray background
                          filled: true, // Apply background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Colors.grey[600]!, // Darker gray border
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: const Icon(Icons.email), // Icon for email
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
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
                              const Icon(Icons.lock), // Icon for password
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Toggle visibility based on the _isPasswordVisible variable
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
                        obscureText: !_isPasswordVisible, // Toggle obscure text
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _register(context);
                        },
                        child: const Text('Register'),
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
                            Navigator.pop(context); // Go back to login
                          },
                          child: const Text(
                            'Already have an account? Log in',
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
