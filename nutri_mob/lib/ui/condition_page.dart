import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Consent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConsentPage(),
    );
  }
}

class ConsentPage extends StatefulWidget {
  @override
  _ConsentPageState createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  bool _healthAwarenessChecked = false;
  bool _trueInfoChecked = false;
  bool _acceptRulesChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Consent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please read and accept the following conditions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('I am concerned about my health awareness.'),
              value: _healthAwarenessChecked,
              onChanged: (bool? value) {
                setState(() {
                  _healthAwarenessChecked = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('I will provide true information and data.'),
              value: _trueInfoChecked,
              onChanged: (bool? value) {
                setState(() {
                  _trueInfoChecked = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('I accept the rules and regulations of the app.'),
              value: _acceptRulesChecked,
              onChanged: (bool? value) {
                setState(() {
                  _acceptRulesChecked = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _healthAwarenessChecked &&
                  _trueInfoChecked &&
                  _acceptRulesChecked
                  ? () {
                // Proceed to next screen or perform action
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Consent Given'),
                    content: Text('Thank you for providing consent.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
                  : null,
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
