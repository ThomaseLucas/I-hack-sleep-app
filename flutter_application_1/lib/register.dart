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

    print(
        "DEBUG: Username: $username, Email: $email, Password: $password"); // Debugging

    const String apiUrl = "http://10.244.30.167:5000/register";

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'username': username, 'email': email, 'password': password}),
      );

      print("DEBUG: Response Status: ${response.statusCode}"); // Debugging
      print("DEBUG: Response Body: ${response.body}"); // Debugging

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
      print("DEBUG: Error registering: $error"); // Debugging
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
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _register(context);
                        },
                        child: const Text('Register'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to login
                        },
                        child: const Text('Already have an account? Log in'),
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