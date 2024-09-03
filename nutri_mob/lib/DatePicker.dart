import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DateOfBirthPicker extends StatefulWidget {
  @override
  _DateOfBirthPickerState createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<DateOfBirthPicker> {
  DateTime _selectedDate = DateTime.now();

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      // Save the selected date to Firebase
      _saveDateToFirebase(_selectedDate);
    }
  }

  Future<void> _saveDateToFirebase(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DatabaseReference bioDataRef =
      FirebaseDatabase.instance.ref().child('users/${user.uid}/bioData');

      await bioDataRef.update({
        'dateOfBirth': date.toIso8601String(), // Store date in ISO 8601 format
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Date of Birth saved successfully'),
        ),
      );

      // Optionally navigate back or to another screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date of Birth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Date: ${_selectedDate.toLocal()}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text('Select Date'),
            ),
          ],
        ),
      ),
    );
  }
}
