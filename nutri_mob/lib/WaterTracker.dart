import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackingScreen extends StatefulWidget {
  @override
  _WaterTrackingScreenState createState() => _WaterTrackingScreenState();
}

class _WaterTrackingScreenState extends State<WaterTrackingScreen> {
  int waterConsumed = 0; // in ml
  final int waterGoal = 3700; // daily goal in ml
  int count250mlGlasses = 0; // Count of 250 ml glasses logged
  int count500mlGlasses = 0; // Count of 500 ml glasses logged

  String _selectedPeriod = 'Daily'; // Default period
  List<int> _dailyData = [0, 250, 500, 750, 1000, 1250, 1500]; // Sample daily data
  List<int> _weeklyData = [0, 500, 1000, 1500, 2000, 2500, 3000]; // Sample weekly data
  List<int> _monthlyData = [0, 2000, 4000, 6000, 8000, 10000, 12000]; // Sample monthly data

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterConsumed', waterConsumed);
    await prefs.setInt('count250mlGlasses', count250mlGlasses);
    await prefs.setInt('count500mlGlasses', count500mlGlasses);
    await prefs.setString('selectedPeriod', _selectedPeriod);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      waterConsumed = prefs.getInt('waterConsumed') ?? 0;
      count250mlGlasses = prefs.getInt('count250mlGlasses') ?? 0;
      count500mlGlasses = prefs.getInt('count500mlGlasses') ?? 0;
      _selectedPeriod = prefs.getString('selectedPeriod') ?? 'Daily';
    });
  }

  void _logWater(int amount) {
    setState(() {
      waterConsumed = (waterConsumed + amount).clamp(0, waterGoal);
      if (amount == 250) {
        count250mlGlasses += 1;
      } else if (amount == 500) {
        count500mlGlasses += 1;
      }
    });
    _saveData();
  }

  // Function to reset all values
  void _resetData() {
    setState(() {
      waterConsumed = 0;
      count250mlGlasses = 0;
      count500mlGlasses = 0;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Tracker',
          style: TextStyle(fontFamily: 'Lexend', color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isPortrait ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDailyWaterTracker(size),
            SizedBox(height: isPortrait ? 20 : 30),
            _buildResetButton(),
            SizedBox(height: isPortrait ? 20 : 30),
            _buildHydrationTips(),
            SizedBox(height: isPortrait ? 20 : 30), // Add the reset button here
          ],
        ),
      ),
    );
  }

  Widget _buildDailyWaterTracker(Size size) {
    double progress = waterConsumed / waterGoal;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Daily Water Goal: $waterGoal ml',
            style: TextStyle(
              fontSize: size.width > 600 ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
              fontFamily: 'Lexend',
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
                        fontFamily: 'Lexend',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildLogWaterButtons(),
          SizedBox(height: 20),
          _buildWaterGlassesCount(),
        ],
      ),
    );
  }

  Widget _buildLogWaterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => _logWater(250),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              icon: Icon(Icons.local_drink, size: 24, color: Colors.white),
              label: Text(
                'Log 250 ml',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Lexend'),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () => _logWater(500),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.3),
              ),
              icon: Icon(Icons.local_drink, size: 24, color: Colors.white),
              label: Text(
                'Log 500 ml',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Lexend'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterGlassesCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGlassCountCard('250 ml Glasses', count250mlGlasses, Colors.blue.shade200),
        _buildGlassCountCard('500 ml Glasses', count500mlGlasses, Colors.blue.shade300),
      ],
    );
  }

  Widget _buildGlassCountCard(String title, int count, Color color) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: 150,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lexend', color: Colors.blue.shade900),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              '$count',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Lexend', color: Colors.blue.shade900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    bool isSelected = _selectedPeriod == period;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedPeriod = period;
          });
          _saveData();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue.shade700 : Colors.blue.shade200,
          minimumSize: Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        child: Text(
          period,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lexend',
          ),
        ),
      ),
    );
  }



  Widget _buildHydrationTips() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hydration Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
              fontFamily: 'Lexend',
            ),
          ),
          SizedBox(height: 10),
          Text(
            '• Drink water before and after meals.\n• Carry a water bottle with you.\n• Monitor your urine color for hydration levels.\n• Add fruits like lemon or mint to your water for a refreshing flavor.',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Lexend',
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: _resetData,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Text(
        'Reset Water Consumption',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Lexend',
        ),
      ),
    );
  }
}
