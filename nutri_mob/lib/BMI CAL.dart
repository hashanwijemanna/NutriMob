import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class BMICalculater extends StatefulWidget {
  const BMICalculater({Key? key}) : super(key: key);

  @override
  State<BMICalculater> createState() => _BMICalculaterState();
}

class _BMICalculaterState extends State<BMICalculater> {
  var wtController = TextEditingController();
  var htController = TextEditingController();
  var agController = TextEditingController();

  var result = "";
  var bgColor = Colors.indigo.shade200;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter your details'),
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
                  'BMI',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 21),
                TextField(
                  controller: wtController,
                  decoration: InputDecoration(
                    label: Text('Enter your Weight(in Kgs)'),
                    prefixIcon: Icon(Icons.line_weight),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: htController,
                  decoration: InputDecoration(
                    label: Text('Enter your Height(in centimeters)'),
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    var wt = wtController.text.toString();
                    var ht = htController.text.toString();
                    var age = agController.text.toString();

                    if (wt != "" && ht != "" && age != "") {
                      // BMI CALCULATION
                      var iWt = int.parse(wt);
                      var iht = int.parse(ht);
                      var iAge = int.parse(age);

                      var tM = iht / 100;
                      var bmi = iWt / (tM * tM);

                      setState(() {
                        result = "Your BMI is ${bmi.toStringAsFixed(2)}";
                      });

                      // Get the current user
                      User? user = _auth.currentUser;
                      if (user != null) {
                        String email = user.email ?? "unknown";

                        // Push data to Firebase Realtime Database
                        await _database
                            .ref("users/${user.uid}/bmiData")
                            .set({
                          "weight": iWt,
                          "height": iht,
                          "age": iAge,
                          "bmi": bmi.toStringAsFixed(2),  // Push BMI value
                          "email": email,
                        });
                      }
                    } else {
                      setState(() {
                        result = "Please fill all the required fields!";
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
                SizedBox(height: 11),
                Text(
                  result,
                  style: TextStyle(fontSize: 19),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
