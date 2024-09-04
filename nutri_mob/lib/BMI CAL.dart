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
  DateTime? selectedDateOfBirth;
  var allergiesController = TextEditingController();
  var foodItemsController = TextEditingController();

  var result = "";
  var bgColor = Colors.blueGrey.shade100;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  List<String> diseases = [
    'Diabetes',
    'Cardiovascular Diseases',
    'Lactose Intolerance',
    'Osteoporosis'
  ];
  List<String> selectedDiseases = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter your details',
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
                  _buildDatePicker(),
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
                  SizedBox(height: 16),
                  _buildDiseaseSelection(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      var wt = wtController.text.toString();
                      var ht = htController.text.toString();
                      var dob = selectedDateOfBirth;
                      var allergies = allergiesController.text.toString();
                      var foodItems = foodItemsController.text.toString();

                      if (wt.isNotEmpty && ht.isNotEmpty && dob != null) {
                        var iWt = int.parse(wt);
                        var iht = int.parse(ht);

                        var tM = iht / 100;
                        var bmi = iWt / (tM * tM);

                        User? user = _auth.currentUser;
                        if (user != null) {
                          String email = user.email ?? "unknown";

                          Map<String, dynamic> userData = {
                            "weight": iWt,
                            "height": iht,
                            "date_of_birth": dob.toIso8601String(),
                            "bmi": bmi.toStringAsFixed(2),
                            "email": email,
                          };

                          if (allergies.isNotEmpty) {
                            userData["allergies"] = allergies;
                          }
                          if (foodItems.isNotEmpty) {
                            userData["food_items_recommended"] = foodItems;
                          }
                          if (selectedDiseases.isNotEmpty) {
                            userData["selected_diseases"] = selectedDiseases;
                          }

                          DatabaseReference userRef = _database.ref("users/${user.uid}");

                          // Save overall user bioData
                          await userRef.child("bioData").set(userData);

                          // Save BMI value with a timestamp
                          String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
                          await userRef.child("bmiRecords").child(timestamp).set({
                            "bmi": bmi.toStringAsFixed(2),
                            "date": DateTime.now().toIso8601String(),
                          });

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

  Widget _buildDatePicker() {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedDateOfBirth == null
                ? 'Select Date of Birth'
                : 'Date of Birth: ${selectedDateOfBirth!.toLocal().toString().split(' ')[0]}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null && pickedDate != selectedDateOfBirth) {
              setState(() {
                selectedDateOfBirth = pickedDate;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildDiseaseSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Non-Infectious Diseases (if any):',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade800,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: diseases.map((disease) {
            return ChoiceChip(
              label: Text(disease),
              selected: selectedDiseases.contains(disease),
              onSelected: (selected) {
                setState(() {
                  selected
                      ? selectedDiseases.add(disease)
                      : selectedDiseases.remove(disease);
                });
              },
              selectedColor: Colors.green.shade200,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: selectedDiseases.contains(disease)
                    ? Colors.white
                    : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
