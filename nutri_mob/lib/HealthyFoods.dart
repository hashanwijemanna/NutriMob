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
              Icons.energy_savings_leaf,
              'Leafy Greens',
              'Spinach, kale, and other leafy greens are rich in vitamins and minerals.',
            ),
            _buildFoodTip(
              Icons.local_dining,
              'Lean Proteins',
              'Chicken, fish, and legumes provide essential proteins without excess fat.',
            ),
            _buildFoodTip(
              Icons.grain,
              'Whole Grains',
              'Opt for whole grains like quinoa, brown rice, and oats for added fiber and nutrients.',
            ),
            _buildFoodTip(
              Icons.av_timer,
              'Nuts and Seeds',
              'Almonds, chia seeds, and flaxseeds are excellent sources of healthy fats and omega-3s.',
            ),
            _buildFoodTip(
              Icons.apple,
              'Fruits',
              'Berries, apples, and oranges are rich in vitamins and antioxidants. Enjoy them fresh or as a smoothie.',
            ),
            _buildFoodTip(
              Icons.local_pizza,
              'Vegetable Soups',
              'Soups made with a variety of vegetables can be both nutritious and filling. Opt for low-sodium options.',
            ),
            _buildFoodTip(
              Icons.icecream,
              'Greek Yogurt',
              'High in protein and probiotics, Greek yogurt is great for digestion and can be a healthy snack or breakfast option.',
            ),
            _buildFoodTip(
              Icons.coffee,
              'Green Tea',
              'Packed with antioxidants, green tea can help improve brain function and boost metabolism.',
            ),
            _buildFoodTip(
              Icons.wb_sunny,
              'Healthy Fats',
              'Include avocados, olive oil, and fatty fish in your diet for heart-healthy fats and essential nutrients.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodTip(IconData icon, String title, String description) {
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
