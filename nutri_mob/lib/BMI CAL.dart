import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nutri_mob/home.dart';
import 'package:nutri_mob/main.dart';

class BMICalculater extends StatefulWidget {
  const BMICalculater({Key? key}) : super(key: key);

  @override
  State<BMICalculater> createState() => _BMICalculaterState();
}

class _BMICalculaterState extends State<BMICalculater> {
  var wtController = TextEditingController();
  var htController = TextEditingController();
  var agController = TextEditingController();
  var allergiesController = TextEditingController();
  var foodItemsController = TextEditingController();

  var result = "";
  var bgColor = Colors.indigo.shade200;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: Colors.white), // Back button color
      ),
      body: Container(
        color: bgColor,
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter your details',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 21),
                TextField(
                  controller: wtController,
                  decoration: InputDecoration(
                    label: Text('Enter your Weight (in Kgs)'),
                    prefixIcon: Icon(Icons.line_weight),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: htController,
                  decoration: InputDecoration(
                    label: Text('Enter your Height (in centimeters)'),
                    prefixIcon: Icon(Icons.height),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 11),
                TextField(
                  controller: agController,
                  decoration: InputDecoration(
                    label: Text('Enter your Age'),
                    prefixIcon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 11),
                TextField(
                  controller: allergiesController,
                  decoration: InputDecoration(
                    label: Text('Enter Allergies (if any)'),
                    prefixIcon: Icon(Icons.warning),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 11),
                TextField(
                  controller: foodItemsController,
                  decoration: InputDecoration(
                    label: Text('Food Items Recommended by Doctors (if any)'),
                    prefixIcon: Icon(Icons.local_dining),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    var wt = wtController.text.toString();
                    var ht = htController.text.toString();
                    var age = agController.text.toString();
                    var allergies = allergiesController.text.toString();
                    var foodItems = foodItemsController.text.toString();

                    if (wt != "" && ht != "" && age != "") {
                      // BMI CALCULATION
                      var iWt = int.parse(wt);
                      var iht = int.parse(ht);
                      var iAge = int.parse(age);

                      var tM = iht / 100;
                      var bmi = iWt / (tM * tM);

                      // Get the current user
                      User? user = _auth.currentUser;
                      if (user != null) {
                        String email = user.email ?? "unknown";

                        // Prepare data to push to Firebase Realtime Database
                        Map<String, dynamic> userData = {
                          "weight": iWt,
                          "height": iht,
                          "age": iAge,
                          "bmi": bmi.toStringAsFixed(2),  // Push BMI value
                          "email": email,
                        };

                        // Add optional fields if they are not empty
                        if (allergies.isNotEmpty) {
                          userData["allergies"] = allergies;
                        }
                        if (foodItems.isNotEmpty) {
                          userData["food_items_recommended"] = foodItems;
                        }

                        // Push data to Firebase Realtime Database
                        await _database.ref("users/${user.uid}/bioData").set(userData);

                        // Navigate to the result page if successful
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        result = "Please fill all the required fields!";
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green, // Button color
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold, // Text bold
                    ),
                  ),
                  child: Text('Submit'),
                ),
                SizedBox(height: 11),
                Text(
                  result,
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.red, // Result text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
