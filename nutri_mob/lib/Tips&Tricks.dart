import 'package:flutter/material.dart';
import 'D2DLife.dart';
import 'HealthyFoods.dart';
import 'HealthyHabits.dart';
import 'MentalWellness.dart'; // Import the new screens
import 'Exe.dart';   // Import the new screens

class HealthTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Health Tips & Tricks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lexend',
          ),
        ),
        backgroundColor: Color(0xFF00B2A9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Tips & Tricks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              'Healthy Day-to-Day Life',
              'Discover daily practices that can enhance your well-being.',
              Icons.accessibility,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HealthyDayToDayLifeScreen()),
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              'Healthy Foods',
              'Explore nutritious foods that support a balanced diet.',
              Icons.fastfood,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HealthyFoodsScreen()),
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              'Healthy Habits',
              'Learn about habits that promote a healthier lifestyle.',
              Icons.monitor_heart_rounded,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HealthyHabitsScreen()),
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              'Mental Wellness',
              'Understand techniques to maintain mental health and reduce stress.',
              Icons.self_improvement,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MentalWellnessScreen()),
              ),
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              'Exercise Tips',
              'Get advice on effective workouts and maintaining physical fitness.',
              Icons.fitness_center,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExerciseTipsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
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
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
