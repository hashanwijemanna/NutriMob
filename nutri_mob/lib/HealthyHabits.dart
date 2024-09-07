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
              Icons.self_improvement,
              'Practice Mindfulness',
              'Engage in mindfulness techniques such as meditation to reduce stress and improve mental health.',
            ),
            _buildHabitTip(
              Icons.smoking_rooms,
              'Avoid Smoking',
              'Refrain from smoking and avoid exposure to second-hand smoke to enhance lung and overall health.',
            ),
            _buildHabitTip(
              Icons.local_drink,
              'Limit Alcohol Consumption',
              'Moderate alcohol intake to reduce risks associated with excessive drinking.',
            ),
            _buildHabitTip(
              Icons.directions_run,
              'Exercise Regularly',
              'Engage in physical activities like walking, running, or gym workouts to maintain cardiovascular health.',
            ),
            _buildHabitTip(
              Icons.nightlife,
              'Get Quality Sleep',
              'Aim for 7-9 hours of sleep each night to allow your body to recover and maintain optimal health.',
            ),
            _buildHabitTip(
              Icons.water,
              'Stay Hydrated',
              'Drink plenty of water throughout the day to keep your body hydrated and functioning properly.',
            ),
            _buildHabitTip(
              Icons.cleaning_services,
              'Maintain Good Hygiene',
              'Regularly wash hands and maintain personal cleanliness to prevent illness and infections.',
            ),
            _buildHabitTip(
              Icons.local_pizza,
              'Eat Balanced Meals',
              'Incorporate a variety of fruits, vegetables, lean proteins, and whole grains into your diet.',
            ),
            _buildHabitTip(
              Icons.language,
              'Stay Socially Active',
              'Maintain social connections and engage in activities that promote positive interactions and relationships.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitTip(IconData icon, String title, String description) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          icon,
          size: 40,
          color: Color(0xFF00B2A9), // Matching color to app bar
        ),
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
