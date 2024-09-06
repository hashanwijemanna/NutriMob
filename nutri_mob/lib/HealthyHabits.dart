import 'package:flutter/material.dart';

class HealthyHabitsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthy Habits'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHabitTip(
              'Practice Mindfulness',
              'Engage in mindfulness techniques such as meditation to reduce stress and improve mental health.',
            ),
            _buildHabitTip(
              'Avoid Smoking',
              'Refrain from smoking and avoid exposure to second-hand smoke to enhance lung and overall health.',
            ),
            _buildHabitTip(
              'Limit Alcohol Consumption',
              'Moderate alcohol intake to reduce risks associated with excessive drinking.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitTip(String title, String description) {
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
