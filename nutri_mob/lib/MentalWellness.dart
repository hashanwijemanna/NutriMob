import 'package:flutter/material.dart';

class MentalWellnessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mental Wellness'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
      ),
      body: SingleChildScrollView(
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
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Practice Gratitude',
              'Keep a journal to regularly write down things you’re grateful for to boost positivity and well-being.',
              Icons.favorite,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Limit Screen Time',
              'Reduce time spent on screens and social media to prevent digital overload and enhance mental health.',
              Icons.screen_search_desktop,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Engage in Hobbies',
              'Pursue activities and hobbies that you enjoy to relieve stress and bring joy into your life.',
              Icons.brush,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Stay Hydrated',
              'Drink plenty of water as dehydration can affect your mood and cognitive function.',
              Icons.local_drink,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Get Adequate Sleep',
              'Aim for 7-9 hours of quality sleep each night to support mental and physical health.',
              Icons.bed,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Set Realistic Goals',
              'Set achievable goals and break them into smaller steps to manage stress and stay motivated.',
              Icons.flag,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(icon, size: 40, color: Color(0xFF00B2A9)), // Matching color to app bar
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade800,
            fontFamily: 'Lexend',
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
