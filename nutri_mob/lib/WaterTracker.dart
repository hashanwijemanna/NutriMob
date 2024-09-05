import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
        title: Text('Water Tracker', style: TextStyle(fontFamily: 'Lexend')),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isPortrait ? 16.0 : 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDailyWaterTracker(size),
            SizedBox(height: isPortrait ? 20 : 30),
            _buildWaterConsumedAnalysis(size),
            SizedBox(height: isPortrait ? 20 : 30),
            _buildHydrationTips(),
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

  Widget _buildWaterConsumedAnalysis(Size size) {
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
          _buildPeriodSelector(),
          SizedBox(height: 20),
          _buildWaterConsumptionChart(),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 10),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
                fontFamily: 'Lexend',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPeriodButton('Daily'),
        _buildPeriodButton('Weekly'),
        _buildPeriodButton('Monthly'),
      ],
    );
  }

  Widget _buildPeriodButton(String period) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedPeriod == period ? Colors.blue.shade700 : Colors.blue.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        period,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Lexend'),
      ),
    );
  }

  Widget _buildWaterConsumptionChart() {
    List<int> data;

    switch (_selectedPeriod) {
      case 'Weekly':
        data = _weeklyData;
        break;
      case 'Monthly':
        data = _monthlyData;
        break;
      case 'Daily':
      default:
        data = _dailyData;
        break;
    }

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
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.blue.shade300,
                width: 1,
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(data.length, (index) => FlSpot(index.toDouble(), data[index].toDouble())),
                isCurved: true,
                color: Colors.blue.shade700, // Updated to `color`
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(enabled: false),
            minX: 0,
            maxX: (data.length - 1).toDouble(),
            minY: 0,
            maxY: data.reduce((a, b) => a > b ? a : b).toDouble(),
          ),
        ),
      ),
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
            fontFamily: 'Lexend',
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
              style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade700, fontFamily: 'Lexend'),
            ),
          ),
        ),
      ],
    );
  }
}
