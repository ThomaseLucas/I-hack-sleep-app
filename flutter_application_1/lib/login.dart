import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'timer.dart';
import 'register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    Future<void> _login() async {
      String username = _usernameController.text;
      String password = _passwordController.text;

      // For this example, we assume any non-empty username/password is valid
      if (username.isNotEmpty && password.isNotEmpty) {
        const String apiUrl = 'http://127.0.0.1:5000/login';


        try {
          var response = await http.post(  // <-- Added: API POST request
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},  // <-- Added: JSON headers
            body: json.encode({
              'username': username,
              'password': password,  // <-- Added: Send credentials
            }),
          );

          if (response.statusCode == 200) {  // <-- Added: Check for successful response
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successful!')),  // <-- Added: Success feedback
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TimerPage()),  // Navigate to TimerPage
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid username or password')),  // <-- Added: Error feedback
            );
          }
        } catch (error) {  // <-- Added: Error handling
          print('Error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error logging in. Please try again later.')),  // <-- Added: Network error handling
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid credentials')),  // <-- Added: Handle empty fields
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
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
    );
  }
}