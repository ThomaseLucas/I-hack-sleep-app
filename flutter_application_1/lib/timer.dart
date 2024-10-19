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
  String username = 'user@example.com';

  void _toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
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

  void _stopTimer() async {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
    await logSleepData(_seconds);
  }

  void _resetTimer() {
    _stopTimer(); // Stop the timer first
    setState(() {
      _seconds = 0; // Reset the seconds to 0
    });
  }

  Future<void> logSleepData(int timeElapsed) async {
    const String apiUrl = 'http://10.0.2.2:5000/log_sleep'; // Change to your API URL

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': username,
          'time_slept': timeElapsed,
          'date': DateTime.now().toIso8601String(),
        }),
      );

      // Check the response status and show a snackbar if needed
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
        const SnackBar(content: Text('Error logging sleep data. Please try again later.')),
      );
    }
  }


  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    // Format the output to display as HH:MM:SS
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
            const Text(
              'Timer is running for:',
            ),
            Text(
              _formatTime(_seconds),
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 10),
            Image.asset(
              _isRunning
                  ? 'assets/frog_asleep.jpg' // Display asleep image
                  : 'assets/frog_awake.jpeg', // Display awake image
            ),

          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            onPressed: _toggleTimer,
            tooltip: _isRunning ? 'Stop Timer' : 'Start Timer',
            child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
          ),

          const SizedBox(height: 16), // Add some space between the buttons
          FloatingActionButton(
            onPressed: _resetTimer,
            tooltip: 'Restart Timer',
            child: const Icon(Icons.replay),
          ),

          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsPage()),
              );
            },
            tooltip: 'View Stats',
            child: const Icon(Icons.show_chart),
          ),

        ],
      ),
    );
  }
}