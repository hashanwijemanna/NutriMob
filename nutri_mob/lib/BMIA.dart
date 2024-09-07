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

  // Function to load BMI records from Firebase
  void _loadBMIRecords() async {
    if (user != null) {
      String userId = user!.uid; // Use current user's UID

      final snapshot = await _dbRef
          .child('users')
          .child('bioData')
          .child('bmiRecords')
          .child(userId)
          .get();

      if (snapshot.exists) {
        Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

        if (values != null) {
          List<BMIRecord> tempList = [];

          values.forEach((key, value) {
            double bmi = (value['bmi'] as num).toDouble(); // Explicit casting
            DateTime date = DateTime.fromMillisecondsSinceEpoch(
                int.parse(value['date'].toString()));
            tempList.add(BMIRecord(date, bmi));
          });

          setState(() {
            _bmiRecords = tempList;
          });
        }
      }
    }
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
        final date = DateTime.now().millisecondsSinceEpoch;

        if (user != null) {
          String userId = user!.uid;

          await _dbRef
              .child('users')
              .child('bioData')
              .child('bmiRecords')
              .child(userId)
              .push()
              .set({
            'bmi': bmi,
            'date': date,
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
        title: Text('BMI Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Input fields for height in cm and weight in kg
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calculateAndSubmitBMI,
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
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text('${date.day}/${date.month} ${date.hour}:${date.minute}'),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text('${value.toStringAsFixed(1)}'),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: Colors.black, width: 1)),
        lineBarsData: [
          LineChartBarData(
            spots: _bmiRecords
                .map((record) => FlSpot(
                record.date.millisecondsSinceEpoch.toDouble(), record.bmi))
                .toList(),
            isCurved: true,
            dotData: FlDotData(show: true),
            color: Colors.blue,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class BMIRecord {
  final DateTime date;
  final double bmi;

  BMIRecord(this.date, this.bmi);
}
