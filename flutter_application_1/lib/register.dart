import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static final TextEditingController _usernameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController _passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    const String api_url = "http://127.0.0.1:5000/register";

    try {
      var response = await http.post(
        Uri.parse(api_url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username, 
          'email': email,
          'password': password
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error registering. Please try again later')),
        );
      }
    } catch(error) {
      print('Error $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error registering. Please try again later.'))
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                // Handle registration logic here
                // You can navigate back to login or main page
                _register(context);
                 // For now, just go back
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
    );
  }
}
