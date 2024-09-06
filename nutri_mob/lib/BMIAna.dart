import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class BMIAnalysisPage extends StatefulWidget {
  @override
  _BMIAnalysisPageState createState() => _BMIAnalysisPageState();
}

class _BMIAnalysisPageState extends State<BMIAnalysisPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<FlSpot> bmiData = [];
  List<String> xLabels = []; // Store x-axis labels here
  bool isMonthly = false;

  @override
  void initState() {
    super.initState();
    _loadBMIData();
  }

  Future<void> _loadBMIData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference ref = _database.ref("users/${user.uid}/bioData/bmiRecords");
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map;
        List<FlSpot> tempData = [];
        List<String> tempLabels = [];

        data.forEach((key, value) {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
          double bmi = double.parse(value.toString());

          double xValue = isMonthly ? dateTime.month.toDouble() : dateTime.day.toDouble();

          tempData.add(FlSpot(xValue, bmi));
          tempLabels.add(DateFormat(isMonthly ? 'MMM' : 'd').format(dateTime)); // Format date
        });

        setState(() {
          bmiData = tempData;
          xLabels = tempLabels; // Update x-axis labels
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMI Analysis',
          style: TextStyle(color: Colors.white),
        ),
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
          children: [
            // Switch between Weekly and Monthly Data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BMI Over ${isMonthly ? 'Month' : 'Day'}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade800,
                    fontFamily: 'Lexend',
                  ),
                ),
                Switch(
                  value: isMonthly,
                  onChanged: (value) {
                    setState(() {
                      isMonthly = value;
                      _loadBMIData(); // Reload data with new settings
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: xLabels.length.toDouble(),
                  minY: 0,
                  maxY: 100,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          final label = (index >= 0 && index < xLabels.length) ? xLabels[index] : '';
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: bmiData,
                      isCurved: true,
                      color: Colors.blueAccent, // Changed to single Color
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
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
