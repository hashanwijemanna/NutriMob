import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'BMI CAL.dart';
import 'package:intl/intl.dart';

class BMIAnalysisPage extends StatefulWidget {
  @override
  _BMIAnalysisPageState createState() => _BMIAnalysisPageState();
}

class _BMIAnalysisPageState extends State<BMIAnalysisPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  List<_BMIData> bmiData = [];
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
        List<_BMIData> tempData = [];

        data.forEach((key, value) {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
          String timePeriod;

          if (isMonthly) {
            timePeriod = "${dateTime.month}/${dateTime.year}";
          } else {
            int weekOfYear = _weekOfYear(dateTime);
            timePeriod = "Week $weekOfYear";
          }

          tempData.add(_BMIData(timePeriod, double.parse(value.toString())));
        });

        setState(() {
          bmiData = tempData;
        });
      }
    }
  }

  int _weekOfYear(DateTime dateTime) {
    int dayOfYear = int.parse(DateFormat("D").format(dateTime));
    return ((dayOfYear - dateTime.weekday + 10) / 7).floor();
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
                  'BMI Over ${isMonthly ? 'Month' : 'Week'}',
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
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'BMI Analysis',
                  textStyle: TextStyle(
                    color: Colors.blueGrey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend',
                  ),
                ),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries>[
                  LineSeries<_BMIData, String>(
                    dataSource: bmiData,
                    xValueMapper: (_BMIData data, _) => data.timePeriod,
                    yValueMapper: (_BMIData data, _) => data.bmi,
                    name: 'BMI',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    color: Colors.blueAccent,
                  ),
                ],
                primaryXAxis: CategoryAxis(
                  title: AxisTitle(text: isMonthly ? 'Months' : 'Weeks'),
                ),
                primaryYAxis: NumericAxis(
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  title: AxisTitle(text: 'BMI'),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Navigate to the BMICalculater page for a new entry
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BMICalculater()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0xFF00B2A9),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5,
              ),
              child: Text(
                'Add New BMI Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BMIData {
  _BMIData(this.timePeriod, this.bmi);

  final String timePeriod; // Change from 'week' to 'timePeriod' to support weeks or months
  final double bmi;
}
