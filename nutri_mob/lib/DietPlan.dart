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
  String? mealType;
  String? diseases;
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
        await fetchMealType(user!.uid);
        await fetchDiseases(user!.uid);
        await fetchBMIAndMeals(user!.uid);
      }
    }
  }

  Future<void> fetchBMIAndMeals(String uid) async {
    final bioDataRef = _databaseRef.child('users/$uid/bioData');
    final bioDataSnapshot = await bioDataRef.once();
    final bioData = bioDataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (bioData != null && bioData.containsKey('bmi')) {
      setState(() {
        bmi = double.tryParse(bioData['bmi'].toString()) ?? 0.0;
      });

      String bmiCategory = determineBMICategory(bmi);
      await fetchMeals(bmiCategory);
    }
  }

  Future<void> fetchMealType(String uid) async {
    final bioDataRef = _databaseRef.child('users/$uid/bioData');
    final bioDataSnapshot = await bioDataRef.once();
    final bioData = bioDataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (bioData != null && bioData.containsKey('dietary_preference')) {
      setState(() {
        mealType = bioData['dietary_preference'].toString();
      });
    }
  }

  Future<void> fetchDiseases(String uid) async {
    final bioDataRef = _databaseRef.child('users/$uid/bioData');
    final bioDataSnapshot = await bioDataRef.once();
    final bioData = bioDataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (bioData != null && bioData.containsKey('selected_disease')) {
      setState(() {
        diseases = bioData['selected_disease'].toString();
      });

      // If the user has selected diseases, fetch disease-specific meals
      await fetchMealsForDiseases(diseases!);
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

  Future<void> fetchMealsForDiseases(String disease) async {
    // Assume disease is part of the database path
    final diseaseMealsRef; //= _databaseRef.child('meals/diseases/$disease/$mealType');

    if(diseases == "Diabetes") {
      diseaseMealsRef = _databaseRef.child('meals/diseases/diabetes/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Cardiovascular Diseases"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/cardiovascular/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Lactose Intolerance"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/lactose/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Osteoporosis"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/osteoporosis/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Cardiovascular Diseases, Lactose Intolerance"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/cardiovascular+lactose/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Cardiovascular Diseases, Osteoporosis"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/cardiovascular+osteoporosis/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Diabetes, Cardiovascular Diseases"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/diabetes+cardiovascular/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Diabetes, Cardiovascular Diseases, Lactose Intolerance"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/diabetes+cardiovascular+lactose/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Diabetes, Cardiovascular Diseases, Lactose Intolerance, Osteoporosis"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/diabetes+cardiovascular+lactose+osteoporosis/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Diabetes, Cardiovascular Diseases, Osteoporosis"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/diabetes+cardiovascular+osteoporosis/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Diabetes, Lactose Intolerance"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/diabetes+lactose/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else if(diseases == "Diabetes, Osteoporosis"){
      diseaseMealsRef = _databaseRef.child('meals/diseases/diabetes+osteoporosis/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }else{
      diseaseMealsRef = _databaseRef.child('meals/diseases/lactose+osteoporosis/Normal/$mealType');
      final breakfastSnapshot = await diseaseMealsRef.child('breakfast').once();
      final lunchSnapshot = await diseaseMealsRef.child('lunch').once();
      final teaSnapshot = await diseaseMealsRef.child('tea').once();
      final dinnerSnapshot = await diseaseMealsRef.child('dinner').once();

      setState(() {
        breakfastMeals = _getShuffledMeals(breakfastSnapshot.snapshot.value);
        lunchMeals = _getShuffledMeals(lunchSnapshot.snapshot.value);
        teaMeals = _getShuffledMeals(teaSnapshot.snapshot.value);
        dinnerMeals = _getShuffledMeals(dinnerSnapshot.snapshot.value);
      });
    }

  }

  List<String> _getShuffledMeals(dynamic mealsData) {
    if (mealsData != null) {
      List<String> meals = [];

      if (mealsData is Map) {
        mealsData.forEach((key, value) {
          if (value is String) {
            meals.add(value);
          } else if (value is Map && value.containsKey('name')) {
            meals.add(value['name'].toString());
          }
        });
      } else if (mealsData is List) {
        meals = mealsData.map((item) => item.toString()).toList();
      }

      meals.shuffle(Random());
      return meals.take(3).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
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
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI: $bmi',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Color(0xFF00B2A9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (diseases != null) ...[
                Text(
                  'Diseases: $diseases',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              SizedBox(height: screenHeight * 0.03),
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
        Row(
          children: [
            Icon(
              Icons.fastfood,
              color: Colors.lightBlueAccent,
              size: screenWidth * 0.06,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              mealType,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.02),
        ...meals.map((meal) => _buildMealCard(meal, screenWidth)).toList(),
      ],
    );
  }

  Widget _buildMealCard(String meal, double screenWidth) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: screenWidth * 0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: EdgeInsets.all(screenWidth * 0.03),
        title: Text(
          meal,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
          ),
        ),
      ),
    );
  }
}
