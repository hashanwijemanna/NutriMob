import 'package:flutter/material.dart';

class MentalWellnessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Wellness'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mental Wellness',
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
              'Practice Mindfulness',
              'Engage in mindfulness practices like meditation or deep breathing to manage stress and improve mental clarity.',
              Icons.self_improvement,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Seek Support',
              'Don’t hesitate to seek professional help or talk to friends and family when dealing with mental health challenges.',
              Icons.people,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Maintain a Healthy Work-Life Balance',
              'Set boundaries between work and personal time to reduce stress and improve overall well-being.',
              Icons.work,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Stay Physically Active',
              'Exercise regularly as it helps improve mood and reduce symptoms of depression and anxiety.',
              Icons.fitness_center,
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
