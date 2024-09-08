import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BMIAnalysisPage extends StatefulWidget {
  @override
  _BMIAnalysisPageState createState() => _BMIAnalysisPageState();
}

class _BMIAnalysisPageState extends State<BMIAnalysisPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<BMIRecord> _bmiRecords = [];
  User? user;
  double _currentBMI = 0.0;
  String _userName = "";
  String? _userEmail;
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadBMIRecords();
  }

  Future<void> _fetchUserData() async {
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      setState(() {
        _userName = userDoc.get('name');
        _userEmail = user!.email;
      });
    }
  }

  // Function to load BMI records from Firebase and filter last 30 days
  void _loadBMIRecords() async {
    if (user != null) {
      String userId = user!.uid; // Use current user's UID

      final snapshot = await _dbRef
          .child('users')
          .child(userId)
          .child('bmiRecords')
          .get();

      if (snapshot.exists) {
        Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

        if (values != null) {
          List<BMIRecord> tempList = [];

          DateTime now = DateTime.now();
          DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));

          values.forEach((key, value) {
            // Safely parse 'bmi' and 'date' values
            double bmi = double.tryParse(value['bmi'].toString()) ?? 0.0; // Safely parse the BMI value
            DateTime date = DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(value['date'].toString()) ?? 0); // Safely parse the date

            // Only add records from the last 30 days
            if (date.isAfter(thirtyDaysAgo) && date.isBefore(now)) {
              tempList.add(BMIRecord(date, bmi));
            }
          });

          // Ensure there are at least 3 records
          if (tempList.length < 3) {
            // If there are fewer than 3 records, duplicate existing records
            while (tempList.length < 3 && tempList.isNotEmpty) {
              tempList.add(tempList.last);  // Duplicate the last record
            }
          }

          // If tempList is still empty, add the current BMI as a single record
          if (tempList.isEmpty && user != null) {
            // Assume current BMI and date is stored somewhere or calculated
            double currentBMI = _calculateCurrentBMI();
            tempList.add(BMIRecord(DateTime.now(), currentBMI));
          }

          setState(() {
            _bmiRecords = tempList;
          });

          if (tempList.isNotEmpty) {
            setState(() {
              _currentBMI = tempList.last.bmi; // Assuming the last record is the most recent BMI
            });
          }
        }
      }
    }
  }


  double _calculateCurrentBMI() {
    // Example logic to calculate or retrieve the current BMI
    // You can replace this with actual logic
    final heightCm = double.tryParse(_heightController.text);
    final weightKg = double.tryParse(_weightController.text);

    if (heightCm != null && weightKg != null) {
      final heightM = heightCm / 100;
      return weightKg / (heightM * heightM);
    }

    return 0.0; // Return 0 if data is not available
  }

  void _calculateAndSubmitBMI() async {
    final heightStr = _heightController.text;
    final weightStr = _weightController.text;

    if (heightStr.isNotEmpty && weightStr.isNotEmpty) {
      final heightCm = double.tryParse(heightStr);
      final weightKg = double.tryParse(weightStr);

      if (heightCm != null && weightKg != null) {
        // Convert height from cm to meters
        final heightM = heightCm / 100;

        // Calculate BMI
        final bmi = weightKg / (heightM * heightM);

        // Format BMI to two decimal places
        final formattedBmi = double.parse(bmi.toStringAsFixed(2));

        final date = DateTime.now().millisecondsSinceEpoch;

        if (user != null) {
          String userId = user!.uid;

          // Add new BMI record
          await _dbRef
              .child('users')
              .child(userId)
              .child('bmiRecords')
              .push()
              .set({
            'bmi': formattedBmi,
            'date': date,
          });

          // Update the latest BMI value in bioData
          await _dbRef
              .child('users')
              .child(userId)
              .child('bioData')
              .update({
            'bmi': formattedBmi,
          });

          _loadBMIRecords(); // Reload the BMI records after submission
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'BMI Chart',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF00B2A9), // Sea light blue
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
        Text(
        'Current BMI: ${_currentBMI.toStringAsFixed(2)}',
        style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.blue,
          ),
        ),
            SizedBox(height: 8.0),

            Text(
              'Enter New Record',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF00B2A9),
              ),
            ),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 8.0), // Added spacing between fields
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calculateAndSubmitBMI,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
              child: Text('Submit'),
            ),
            SizedBox(height: 16.0),
            _bmiRecords.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Expanded(child: _buildChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        // Enhancing grid style
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.5),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.5),
            strokeWidth: 1,
          ),
        ),
        // Adding a title to the chart
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              // Adjusting interval for better spacing of X-axis labels (dates)
              interval: 3 * 24 * 60 * 60 * 1000, // 3-day intervals
              getTitlesWidget: (value, meta) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    '${date.day}/${date.month}', // Format as day/month
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2, // Interval for BMI values on Y-axis
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toStringAsFixed(1), // Display BMI with one decimal point
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        // Adding border and improving visibility
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.blueGrey, width: 2),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: _bmiRecords
                .map((record) => FlSpot(
                record.date.millisecondsSinceEpoch.toDouble(), record.bmi))
                .toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.greenAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.greenAccent.withOpacity(0.2)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        // Set min and max values for Y-axis
        minY: 0, // Minimum value for Y-axis
        maxY: 50, // Maximum value for Y-axis
      ),
    );
  }
}

class BMIRecord {
  final DateTime date;
  final double bmi;

  BMIRecord(this.date, this.bmi);
}
