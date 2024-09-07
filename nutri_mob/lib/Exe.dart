import 'package:flutter/material.dart';

class ExerciseTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Tips'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
      ),
      body: SingleChildScrollView(
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
              Icons.fitness_center,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Incorporate Variety',
              'Mix up your routine with different types of exercises to work different muscle groups and prevent boredom.',
              Icons.sync,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Cool Down After Exercise',
              'Finish with a cool-down session to help your body recover and prevent muscle stiffness.',
              Icons.timer,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Set Realistic Goals',
              'Set achievable fitness goals and track your progress to stay motivated and on track.',
              Icons.flag,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Use Proper Equipment',
              'Ensure you have the right equipment for your exercises to improve performance and reduce risk of injury.',
              Icons.sports_martial_arts,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Listen to Your Body',
              'Pay attention to your body’s signals and avoid pushing through pain or discomfort.',
              Icons.monitor,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Get Adequate Rest',
              'Ensure you get enough rest and recovery time between workouts to allow your body to heal and grow stronger.',
              Icons.bed,
            ),
            SizedBox(height: 20),
            _buildTipCard(
              context,
              'Maintain Consistency',
              'Stick to your exercise routine consistently for long-term benefits and better results.',
              Icons.calendar_today,
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
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
