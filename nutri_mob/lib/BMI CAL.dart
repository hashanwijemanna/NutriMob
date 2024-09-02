import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:nutri_mob/home.dart';

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
  var bgColor = Colors.blueGrey.shade100;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BMI Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade800,
        iconTheme: IconThemeData(color: Colors.white), // Back button color
      ),
      body: Container(
        color: bgColor,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your details',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: wtController,
                    label: 'Weight (in Kgs)',
                    icon: Icons.line_weight,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: htController,
                    label: 'Height (in centimeters)',
                    icon: Icons.height,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: agController,
                    label: 'Age',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: allergiesController,
                    label: 'Allergies (if any)',
                    icon: Icons.warning,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    controller: foodItemsController,
                    label: 'Food Items Recommended (if any)',
                    icon: Icons.local_dining,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      var wt = wtController.text.toString();
                      var ht = htController.text.toString();
                      var age = agController.text.toString();
                      var allergies = allergiesController.text.toString();
                      var foodItems = foodItemsController.text.toString();

                      if (wt.isNotEmpty && ht.isNotEmpty && age.isNotEmpty) {
                        var iWt = int.parse(wt);
                        var iht = int.parse(ht);
                        var iAge = int.parse(age);

                        var tM = iht / 100;
                        var bmi = iWt / (tM * tM);

                        User? user = _auth.currentUser;
                        if (user != null) {
                          String email = user.email ?? "unknown";

                          Map<String, dynamic> userData = {
                            "weight": iWt,
                            "height": iht,
                            "age": iAge,
                            "bmi": bmi.toStringAsFixed(2),
                            "email": email,
                          };

                          if (allergies.isNotEmpty) {
                            userData["allergies"] = allergies;
                          }
                          if (foodItems.isNotEmpty) {
                            userData["food_items_recommended"] = foodItems;
                          }

                          await _database.ref("users/${user.uid}/bioData").set(userData);

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
                      backgroundColor: Colors.green, // Button color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueGrey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade600),
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}
