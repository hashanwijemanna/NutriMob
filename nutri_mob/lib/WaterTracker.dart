import 'package:flutter/material.dart';

class WaterTrackingScreen extends StatefulWidget {
  @override
  _WaterTrackingScreenState createState() => _WaterTrackingScreenState();
}

class _WaterTrackingScreenState extends State<WaterTrackingScreen> {
  int waterConsumed = 0; // in ml
  final int waterGoal = 3700; // daily goal in ml
  int count250mlGlasses = 0; // Count of 250 ml glasses logged
  int count500mlGlasses = 0; // Count of 500 ml glasses logged

  void _logWater(int amount) {
    setState(() {
      waterConsumed = (waterConsumed + amount).clamp(0, waterGoal);
      if (amount == 250) {
        count250mlGlasses += 1; // Increment the count for 250 ml glasses
      } else if (amount == 500) {
        count500mlGlasses += 1; // Increment the count for 500 ml glasses
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Tracker'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isPortrait ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildWaterLevelTracker(size),
            SizedBox(height: isPortrait ? 20 : 30),
            _buildLogWaterButtons(),
            SizedBox(height: isPortrait ? 20 : 30),
            _buildWaterGlassesCount(),
            SizedBox(height: isPortrait ? 20 : 30),
            _buildHydrationTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterLevelTracker(Size size) {
    double progress = waterConsumed / waterGoal;
    return Column(
      children: [
        Text(
          'Daily Water Goal: $waterGoal ml',
          style: TextStyle(
            fontSize: size.width > 600 ? 24 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size.width > 600 ? 240 : 220,
              height: size.width > 600 ? 240 : 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade300],
                ),
              ),
            ),
            Container(
              width: size.width > 600 ? 220 : 200,
              height: size.width > 600 ? 220 : 200,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AnimatedContainer(
                    width: size.width > 600 ? 220 : 200,
                    height: (size.width > 600 ? 220 : 200) * progress,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade900],
                      ),
                    ),
                    duration: Duration(milliseconds: 500),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: size.width > 600 ? 34 : 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogWaterButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => _logWater(250),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            minimumSize: Size(220, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          icon: Icon(Icons.local_drink, size: 24, color: Colors.white),
          label: Text(
            'Log 250 ml',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () => _logWater(500),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            minimumSize: Size(220, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          icon: Icon(Icons.local_drink, size: 24, color: Colors.white),
          label: Text(
            'Log 500 ml',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterGlassesCount() {
    int totalGlassesCount = count250mlGlasses + count500mlGlasses;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Water Glasses Logged:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '250 ml Glasses: $count250mlGlasses',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        Text(
          '500 ml Glasses: $count500mlGlasses',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        Text(
          'Total Glasses: $totalGlassesCount',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildHydrationTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hydration Tips:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
        SizedBox(height: 10),
        Card(
          color: Colors.blue.shade50,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '1. Drink water regularly throughout the day.\n'
                  '2. Carry a water bottle with you.\n'
                  '3. Include water-rich foods in your diet.\n'
                  '4. Avoid sugary and caffeinated drinks.',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade700),
            ),
          ),
        ),
      ],
    );
  }
}
