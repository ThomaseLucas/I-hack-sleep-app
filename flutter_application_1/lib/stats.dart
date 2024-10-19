import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  Future<List<dynamic>> fetchLeaderboard() async {
    const String apiUrl =
        'https://sleep.solarwolf.xyz/leaderboard'; // Adjust IP if necessary

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }

  Widget _buildTrophyIcon(int rank) {
    if (rank == 1) {
      return Icon(Icons.emoji_events,
          color: const Color.fromARGB(255, 247, 242, 90),
          size: 24.0); // Gold for 1st place
    } else if (rank == 2) {
      return Icon(Icons.emoji_events,
          color: Colors.grey, size: 24.0); // Silver for 2nd place
    } else if (rank == 3) {
      return Icon(Icons.emoji_events,
          color: const Color.fromARGB(255, 183, 148, 44),
          size: 24.0); // Bronze for 3rd place
    } else {
      return const SizedBox.shrink(); // No icon for other ranks
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
                final rank = index + 1;
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('$rank'),
                    ),
                    title: Text(leaderboard[index]['_id'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Total Hours: ${leaderboard[index]['total_hours']}'),
                    trailing: _buildTrophyIcon(rank),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
