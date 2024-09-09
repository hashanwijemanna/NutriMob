import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'BMIA.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String userName = '';
  String userEmail = '';
  String age = '';
  String height = '';
  String weight = '';
  String bmi = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      DatabaseReference bioDataRef =
      FirebaseDatabase.instance.ref().child('users/${user.uid}/bioData');
      DataSnapshot bioData = await bioDataRef.get();

      DateTime? dob;
      if (bioData.child('date_of_birth').value != null) {
        dob = DateTime.parse(bioData.child('date_of_birth').value.toString());
      }

      setState(() {
        userName = userDoc['name'] ?? 'User Name';
        userEmail = user.email ?? 'user@example.com';
        age = dob != null
            ? _calculateAge(dob).toString() + ' years'
            : 'Age not available';
        height = bioData.child('height').value.toString() + ' cm';
        weight = bioData.child('weight').value.toString() + ' kg';
        bmi = bioData.child('bmi').value.toString();
      });
    }
  }

  int _calculateAge(DateTime dateOfBirth) {
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (dateOfBirth.month > today.month ||
        (dateOfBirth.month == today.month && dateOfBirth.day > today.day)) {
      age--;
    }
    return age;
  }

  Future<void> _edit() async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BMIAnalysisPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 18, // Reduced font size
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF00B2A9),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 120, // Further increased size of the profile picture
                backgroundImage:
                const AssetImage('assets/UserPic.gif'), // Load the asset image
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(height: 16),
              // User Name and Email
              Text(
                userName,
                style: TextStyle(
                  fontSize: 22, // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue.shade900,
                  fontFamily: 'Lexend',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 14, // Reduced font size
                  color: Colors.grey.shade600,
                  fontFamily: 'Lexend',
                ),
              ),
              const SizedBox(height: 32),
              // User Information
              _buildInfoCard(
                'Age',
                age,
                Icons.cake,
                Colors.orangeAccent,
              ),
              _buildInfoCard(
                'Height',
                height,
                Icons.height,
                Colors.blueAccent,
              ),
              _buildInfoCard(
                'Weight',
                weight,
                Icons.fitness_center,
                Colors.greenAccent,
              ),
              _buildInfoCard(
                'BMI',
                bmi,
                Icons.monitor_weight,
                Colors.purpleAccent,
              ),
              const SizedBox(height: 32),
              // Stylish Logout Button
              ElevatedButton.icon(
                onPressed: _edit,
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Edit Bio Data',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,// Reduced font size
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00B2A9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, IconData icon, Color iconColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Slightly more rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Further reduced padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20), // Further reduced icon size
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16, // Further reduced font size
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue.shade900,
                    fontFamily: 'Lexend',
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16, // Further reduced font size
                color: Colors.grey.shade700,
                fontFamily: 'Lexend',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
