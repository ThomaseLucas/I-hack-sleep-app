import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'stats.dart';
import 'dart:convert';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  late String username; // Now the username is dynamically set

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the username from the Navigator arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args.containsKey('username')) {
      username = args['username'] as String;
    } else {
      return;
    }
  }

  void _toggleTimer() {
    if (_isRunning) {
      _resetTimer(); // Reset the timer and log the data when stopping
    } else {
      _startTimer(); // Start the timer if it isn't running
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() async {
    _stopTimer(); // Stop the timer first
    setState(() {
      _seconds = 0; // Reset the seconds to 0
    });
    await logSleepData(_seconds); // Log the sleep data after reset
  }

  Future<void> logSleepData(int timeElapsed) async {
    const String apiUrl = 'http://192.168.56.1:5000/log_sleep'; // API URL

    try {
      double hoursSlept = timeElapsed / 3600;

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': username, // Use the logged-in username
          'time_slept': hoursSlept,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sleep data logged successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to log sleep data.')),
        );
      }
    } catch (error) {
      print("DEBUG: Error logging sleep data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error logging sleep data. Please try again later.')),
      );
    }
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            const Text('Timer is running for:'),
            Text(
              _formatTime(_seconds),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Image.asset(
              _isRunning ? 'assets/frog_asleep.jpg' : 'assets/frog_awake.jpeg',
            ),
            const SizedBox(height: 20), // Add some space below the image
            ElevatedButton(
              onPressed: _toggleTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBF77F6), // Set button color
                minimumSize: const Size(200, 50), // Set button size
              ),
              child: Text(
                _isRunning ? 'Stop Tracking' : 'Start Tracking',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            if (_isRunning)
              ElevatedButton(
                onPressed: _stopTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBF77F6), // Set button color
                  shape: const CircleBorder(), // Make the button circular
                  padding: const EdgeInsets.all(20), // Add padding for the icon
                ),
                child: const Icon(
                  Icons.pause, // Use the pause icon
                  size: 40, // Set the icon size
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StatsPage()),
          );
        },
        tooltip: 'View Stats',
        child: const Icon(Icons.show_chart),
      ),
    );
  }
}
