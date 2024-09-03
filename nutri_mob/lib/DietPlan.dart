import 'package:flutter/material.dart';

class DietPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan'),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0F8F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Daily Diet Plan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade800,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildMealCard(
                    title: 'Breakfast',
                    description: 'Oatmeal with fresh fruits and nuts. High in fiber and protein.',
                    imagePath: 'assets/breakfast.jpg', // Replace with your asset
                  ),
                  SizedBox(height: 20),
                  _buildMealCard(
                    title: 'Lunch',
                    description: 'Grilled chicken salad with quinoa. Packed with nutrients and low in calories.',
                    imagePath: 'assets/lunch.jpg', // Replace with your asset
                  ),
                  SizedBox(height: 20),
                  _buildMealCard(
                    title: 'Dinner',
                    description: 'Baked salmon with steamed vegetables. Rich in omega-3 and vitamins.',
                    imagePath: 'assets/dinner.jpg', // Replace with your asset
                  ),
                  SizedBox(height: 20),
                  _buildMealCard(
                    title: 'Snacks',
                    description: 'Greek yogurt with honey and almonds. Perfect for a quick, healthy snack.',
                    imagePath: 'assets/snacks.jpg', // Replace with your asset
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard({required String title, required String description, required String imagePath}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Lexend',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Lexend',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
