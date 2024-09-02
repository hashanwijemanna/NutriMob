import 'package:flutter/material.dart';

class RulesAndRegulationsPage extends StatelessWidget {
  const RulesAndRegulationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rules and Regulations'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
      ),
      body: Container(
        color: Color(0xFFE0F8F7), // Light sea blue background
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildRuleSection(
              imagePath: 'assets/rule1.png', // Update with your image path
              title: 'Rule 1: Respect Privacy',
              description: 'Ensure the privacy of all users by not sharing personal information without consent.',
            ),
            const SizedBox(height: 20),
            _buildRuleSection(
              imagePath: 'assets/rule2.png', // Update with your image path
              title: 'Rule 2: Use Proper Language',
              description: 'Always use appropriate language and avoid offensive or inappropriate comments.',
            ),
            const SizedBox(height: 20),
            _buildRuleSection(
              imagePath: 'assets/rule3.png', // Update with your image path
              title: 'Rule 3: Follow Guidelines',
              description: 'Adhere to the provided guidelines and protocols to ensure smooth operations.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleSection({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rule icon/image
          Image.asset(
            imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          // Rule title and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00B2A9), // Sea light blue
                    fontFamily: 'Lexend',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
