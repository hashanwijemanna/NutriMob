import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HealthStatusScreen extends StatefulWidget {
  @override
  _HealthStatusScreenState createState() => _HealthStatusScreenState();
}

class _HealthStatusScreenState extends State<HealthStatusScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseReference _databaseReference;

  double _bmi = 0.0;
  double _weight = 0.0;
  double _height = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the screen loads
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Fetch bioData (bmi, weight, height) from Realtime Database
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref('users/${user.uid}/bioData');
        DataSnapshot snapshot = await databaseReference.get();

        if (snapshot.exists) {
          // Debug: Check the actual data retrieved
          print('Data snapshot: ${snapshot.value}');

          setState(() {
            // Get BMI, weight, and height from Realtime Database and convert string to double
            _bmi = double.tryParse(snapshot.child('bmi').value.toString()) ?? 0.0;
            _weight = double.tryParse(snapshot.child('weight').value.toString()) ?? 0.0;
            _height = double.tryParse(snapshot.child('height').value.toString()) ?? 0.0;

            // Debug: Ensure values are parsed correctly
            print('BMI: $_bmi, Weight: $_weight, Height: $_height');
          });
        } else {
          // Debug: No data found at the specified path
          print('No data found at path: users/${user.uid}/bioData');
        }
      } catch (e) {
        // Handle errors here
        print('Error fetching data: $e');
      }
    }
  }

  String _getHealthStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal weight';
    } else if (bmi >= 25 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obesity';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health Status',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF00B2A9),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
              _buildSectionTitle('Current Health Status'),
              SizedBox(height: 16),
              _buildHealthMetrics(),
              SizedBox(height: 16),
              _buildTipsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey.shade800,
        fontFamily: 'Lexend',
      ),
    );
  }

  Widget _buildHealthMetrics() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMetricRow('BMI:', _bmi.toStringAsFixed(1), Colors.blueAccent),
            SizedBox(height: 8),
            _buildMetricRow('Weight:', '$_weight kg', Colors.green),
            SizedBox(height: 8),
            _buildMetricRow('Height:', '$_height cm', Colors.orange),
            SizedBox(height: 8),
            _buildMetricRow('Health Status:', _getHealthStatus(_bmi), Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Lexend',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: 'Lexend',
          ),
        ),
      ],
    );
  }

  Widget _buildTipsSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Health Tips'),
            SizedBox(height: 8),
            Text(
              '• Stay hydrated by drinking plenty of water.\n'
                  '• Follow a balanced diet with fruits and vegetables.\n'
                  '• Exercise regularly to maintain a healthy weight.\n'
                  '• Get enough sleep and manage stress effectively.\n'
                  '• Avoid smoking and excessive alcohol consumption.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'Lexend',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
