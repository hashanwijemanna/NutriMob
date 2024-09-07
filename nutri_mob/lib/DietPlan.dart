import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class DietPlanPage extends StatefulWidget {
  @override
  _DietPlanPageState createState() => _DietPlanPageState();
}

class _DietPlanPageState extends State<DietPlanPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  User? user;
  double bmi = 0.0;
  List<String> breakfastMeals = [];
  List<String> lunchMeals = [];
  List<String> teaMeals = [];
  List<String> dinnerMeals = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (userDoc.exists) {
        await fetchBMIAndMeals(user!.uid);
      }
    }
  }

  Future<void> fetchBMIAndMeals(String uid) async {
    final bioDataRef = _databaseRef.child('users/$uid/bioData');
    final bioDataSnapshot = await bioDataRef.once();
    final bioData = bioDataSnapshot.snapshot.value as Map<dynamic, dynamic>;

    if (bioData != null && bioData.containsKey('bmi')) {
      setState(() {
        bmi = double.tryParse(bioData['bmi'].toString()) ?? 0.0;
      });

      String bmiCategory = determineBMICategory(bmi);
      await fetchMeals(bmiCategory);
    }
  }

  String determineBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'normal';
    } else if (bmi >= 25 && bmi < 30) {
      return 'overweight';
    } else {
      return 'obesity';
    }
  }

  Future<void> fetchMeals(String bmiCategory) async {
    String mealType = 'veg'; // or 'non-veg', modify based on user preferences

    final mealsRef = _databaseRef.child('meals/$bmiCategory/$mealType');

    final breakfastSnapshot = await mealsRef.child('breakfast').once();
    final lunchSnapshot = await mealsRef.child('lunch').once();
    final teaSnapshot = await mealsRef.child('tea').once();
    final dinnerSnapshot = await mealsRef.child('dinner').once();

    setState(() {
      breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
      lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
      teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
      dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
    });
  }

  List<String> _getShuffledMeals(dynamic mealsData) {
    if (mealsData != null) {
      List<String> meals = [];
      mealsData.forEach((key, value) {
        if (value is String) {
          meals.add(value);
        } else if (value is List) {
          for (var item in value) {
            if (item is String) {
              meals.add(item);
            }
          }
        } else if (value is Map) {
          if (value.containsKey('name')) {
            meals.add(value['name'].toString());
          }
        }
      });
      meals.shuffle(Random());
      return meals.take(3).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00B2A9),
        title: Text('Your Diet Plan', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // 5% of the screen width
            vertical: screenHeight * 0.02, // 2% of the screen height
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI: $bmi',
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // 5% of the screen width for font size
                  color: Color(0xFF00B2A9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.03), // 3% of screen height
              _buildMealSection('Breakfast', breakfastMeals, screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildMealSection('Lunch', lunchMeals, screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildMealSection('Tea', teaMeals, screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildMealSection('Dinner', dinnerMeals, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealSection(String mealType, List<String> meals, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealType,
          style: TextStyle(
            fontSize: screenWidth * 0.045, // Slightly smaller than the BMI font
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent,
          ),
        ),
        SizedBox(height: screenWidth * 0.02), // Dynamic spacing based on width
        ...meals.map((meal) => Container(
          margin: EdgeInsets.only(bottom: screenWidth * 0.02), // Dynamic margin
          padding: EdgeInsets.all(screenWidth * 0.03), // Dynamic padding
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            meal,
            style: TextStyle(
              fontSize: screenWidth * 0.04, // Dynamic font size for meals
            ),
          ),
        )),
      ],
    );
  }
}
