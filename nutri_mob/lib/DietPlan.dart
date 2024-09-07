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
        // Fetch BMI and meals
        await fetchBMIAndMeals(user!.uid);
      }
    }
  }

  Future<void> fetchBMIAndMeals(String uid) async {
    // Fetch user's BMI from Firebase Realtime Database
    final bioDataRef = _databaseRef.child('users/$uid/bioData');
    final bioDataSnapshot = await bioDataRef.once();
    final bioData = bioDataSnapshot.snapshot.value as Map<dynamic, dynamic>;

    if (bioData != null && bioData.containsKey('bmi')) {
      setState(() {
        // Ensure that the BMI is converted to double if it's stored as a String
        bmi = double.tryParse(bioData['bmi'].toString()) ?? 0.0;
      });

      // Determine BMI category
      String bmiCategory = determineBMICategory(bmi);

      // Fetch meals from Firebase based on BMI category
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

    // Fetching meals from Firebase Database under BMI category
    final mealsRef = _databaseRef.child('meals/$bmiCategory/$mealType');

    final breakfastSnapshot = await mealsRef.child('breakfast').once();
    final lunchSnapshot = await mealsRef.child('lunch').once();
    final teaSnapshot = await mealsRef.child('tea').once();
    final dinnerSnapshot = await mealsRef.child('dinner').once();

    // Process and shuffle meals
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
          meals.add(value);  // Add the meal if it's a String
        } else if (value is List) {
          // If value is a list, extract the items and add to meals list
          for (var item in value) {
            if (item is String) {
              meals.add(item);  // Add each string in the list to the meals
            }
          }
        } else if (value is Map) {
          // If value is a map, extract the 'name' or relevant key and add to meals
          if (value.containsKey('name')) {
            meals.add(value['name'].toString());
          }
        }
      });
      meals.shuffle(Random());
      return meals.take(3).toList(); // Retrieve 3 meals
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Diet Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BMI: $bmi', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('Breakfast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...breakfastMeals.map((meal) => Text(meal)).toList(),
            SizedBox(height: 20),
            Text('Lunch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...lunchMeals.map((meal) => Text(meal)).toList(),
            SizedBox(height: 20),
            Text('Tea', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...teaMeals.map((meal) => Text(meal)).toList(),
            SizedBox(height: 20),
            Text('Dinner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...dinnerMeals.map((meal) => Text(meal)).toList(),
          ],
        ),
      ),
    );
  }
}
