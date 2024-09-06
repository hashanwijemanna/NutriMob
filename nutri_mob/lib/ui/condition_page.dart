import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConditionPage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}

class ConditionPage extends StatefulWidget {
  @override
  _ConditionPageState createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  bool _isHealthAwarenessChecked = false;
  bool _isTrueInformationChecked = false;
  bool _isTermsAndConditionsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conditions"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                'Before You Proceed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Please accept the following conditions:',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 30),
            _buildCustomCheckbox(
              title: "I am aware of my health and concerned about my well-being.",
              value: _isHealthAwarenessChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isHealthAwarenessChecked = value ?? false;
                });
              },
            ),
            _buildCustomCheckbox(
              title: "I agree to provide my true information and data.",
              value: _isTrueInformationChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isTrueInformationChecked = value ?? false;
                });
              },
            ),
            _buildCustomCheckbox(
              title: "I accept the rules and regulations provided by the app.",
              value: _isTermsAndConditionsChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isTermsAndConditionsChecked = value ?? false;
                });
              },
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _isHealthAwarenessChecked &&
                    _isTrueInformationChecked &&
                    _isTermsAndConditionsChecked
                    ? () {
                  // Handle button press
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("All conditions accepted!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
                    : null, // Disable button if conditions are not met
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.teal, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCheckbox({
    required String title,
    required bool value,
    required void Function(bool?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.teal,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
