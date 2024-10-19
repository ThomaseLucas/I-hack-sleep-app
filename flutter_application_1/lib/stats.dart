import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  Future<List<dynamic>> fetchLeaderboard() async {
    const String apiUrl =
        'http://192.168.56.1:5000/leaderboard'; // Adjust IP if necessary
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final leaderboard = snapshot.data!;
            return ListView.builder(
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(leaderboard[index]['_id']),
                  subtitle:
                      Text('Total Hours: ${leaderboard[index]['total_hours']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
