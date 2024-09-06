import 'package:flutter/material.dart';

class HealthyFoodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthy Foods'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildFoodTip(
              'Leafy Greens',
              'Spinach, kale, and other leafy greens are rich in vitamins and minerals.',
            ),
            _buildFoodTip(
              'Lean Proteins',
              'Chicken, fish, and legumes provide essential proteins without excess fat.',
            ),
            _buildFoodTip(
              'Whole Grains',
              'Opt for whole grains like quinoa, brown rice, and oats for added fiber and nutrients.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodTip(String title, String description) {
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
