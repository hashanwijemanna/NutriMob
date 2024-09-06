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
              Icons.local_drink,
              'Stay Hydrated',
              'Drink plenty of water throughout the day to stay hydrated and maintain overall health.',
            ),
            _buildTip(
              Icons.directions_run,
              'Exercise Regularly',
              'Incorporate physical activity into your daily routine, such as walking, jogging, or yoga.',
            ),
            _buildTip(
              Icons.bed,
              'Get Adequate Sleep',
              'Aim for 7-8 hours of quality sleep each night to support your physical and mental well-being.',
            ),
            _buildTip(
              Icons.restaurant,
              'Eat Balanced Meals',
              'Include a variety of fruits, vegetables, lean proteins, and whole grains in your diet.',
            ),
            _buildTip(
              Icons.spa,
              'Practice Relaxation Techniques',
              'Engage in activities like meditation, deep breathing, or progressive muscle relaxation.',
            ),
            _buildTip(
              Icons.accessibility_new,
              'Stay Active Throughout the Day',
              'Avoid prolonged periods of sitting; take breaks and stretch or walk around regularly.',
            ),
            _buildTip(
              Icons.sunny,
              'Get Some Sunlight',
              'Spend time outdoors to get natural sunlight, which helps regulate your circadian rhythm and vitamin D levels.',
            ),
            _buildTip(
              Icons.smoke_free,
              'Avoid Smoking and Excessive Alcohol',
              'Steer clear of smoking and limit alcohol consumption to promote overall health.',
            ),
            _buildTip(
              Icons.clean_hands,
              'Maintain Good Hygiene',
              'Practice regular hand washing and maintain personal hygiene to prevent illness.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(IconData icon, String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 16),
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
