import 'package:flutter/material.dart';

class HealthyDayToDayLifeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthy Day-to-Day Life'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTip(
              'Stay Hydrated',
              'Drink plenty of water throughout the day to stay hydrated and maintain overall health.',
            ),
            _buildTip(
              'Exercise Regularly',
              'Incorporate physical activity into your daily routine, such as walking, jogging, or yoga.',
            ),
            _buildTip(
              'Get Adequate Sleep',
              'Aim for 7-8 hours of quality sleep each night to support your physical and mental well-being.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
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
