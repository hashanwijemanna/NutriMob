import 'package:flutter/material.dart';

class ExerciseTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Tips'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise Tips',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Warm Up Properly',
              'Always start your workout with a warm-up to prepare your muscles and prevent injury.',
              Icons.accessibility,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Stay Hydrated',
              'Drink plenty of water before, during, and after exercise to stay hydrated and maintain performance.',
              Icons.local_drink,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Focus on Form',
              'Ensure proper form during exercises to maximize effectiveness and minimize risk of injury.',
              Icons.sports,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Incorporate Variety',
              'Mix up your routine with different types of exercises to work different muscle groups and prevent boredom.',
              Icons.sync,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(icon, size: 40, color: Color(0xFF00B2A9)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
            fontFamily: 'Lexend',
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
