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
  List<String> foodItemsList = []; // List to store food items

  var result = "";
  var bgColor = Colors.blue.shade50;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  List<String> diseases = [
    'Diabetes',
    'Cardiovascular Diseases',
    'Lactose Intolerance',
    'Osteoporosis',
  ];

  List<String> allergies = [
    'Dust mites',
    'Food allergies',
    'Certain chemicals',
    'Latex',
    'Medication',
  ];

  List<String> selectedDiseases = [];
  List<String> selectedAllergies = [];

  String? selectedGender = 'None';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lexend', // Set Lexend as the default font
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14, // Decreased font size
          ),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            color: Colors.black,
            fontSize: 18, // Decreased font size
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 14, // Decreased font size
          ),
          bodySmall: TextStyle(
            color: Colors.black,
            fontSize: 12, // Decreased font size
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Enter Your Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue.shade700,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          color: bgColor,
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 450),
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
                    SizedBox(height: 15),
                    _buildGenderSelection(),
                    SizedBox(height: 12),
                    _buildTextField(
                      controller: wtController,
                      label: 'Weight (in Kgs)',
                      icon: Icons.line_weight,
                    ),
                    SizedBox(height: 12),
                    _buildTextField(
                      controller: htController,
                      label: 'Height (in centimeters)',
                      icon: Icons.height,
                    ),
                    SizedBox(height: 10),
                    _buildDatePicker(),
                    SizedBox(height: 10),
                    _buildMultiSelect(
                      label: 'Select Diseases (if any):',
                      options: diseases,
                      selectedItems: selectedDiseases,
                      onChanged: (selected) {
                        setState(() {
                          selectedDiseases = selected;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildMultiSelect(
                      label: 'Select Allergies (if any):',
                      options: allergies,
                      selectedItems: selectedAllergies,
                      onChanged: (selected) {
                        setState(() {
                          selectedAllergies = selected;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildFoodItemsInput(), // Updated method for food items input
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        var wt = wtController.text.toString();
                        var ht = htController.text.toString();
                        var dob = selectedDateOfBirth;
                        var foodItems = foodItemsList.join(', ');

                        if (wt.isNotEmpty &&
                            ht.isNotEmpty &&
                            dob != null &&
                            selectedGender != 'None') {
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
                              "gender": selectedGender,
                            };

                            if (selectedAllergies.isNotEmpty) {
                              userData["allergies"] = selectedAllergies.join(', ');
                            }
                            if (foodItems.isNotEmpty) {
                              userData["food_items_recommended"] = foodItems;
                            }
                            if (selectedDiseases.isNotEmpty) {
                              userData["selected_disease"] = selectedDiseases.join(', ');
                            }

                            DatabaseReference userRef =
                            _database.ref("users/${user.uid}");

                            // Save overall user bioData
                            await userRef.child("bioData").set(userData);

                            // Save BMI value with a timestamp
                            String timestamp =
                            DateTime.now().millisecondsSinceEpoch.toString();
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
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
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
                        fontSize: 14, // Decreased font size
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
      ),
      keyboardType: TextInputType.number,
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.blue.shade700),
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

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedGender = 'Male';
            });
          },
          child: CircleAvatar(
            radius: 70,
            backgroundColor: selectedGender == 'Male'
                ? Colors.blue.shade700
                : Colors.grey.shade300,
            child: ClipOval(
              child: Image.asset(
                'assets/male.gif',
                width: 135,
                height: 135,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedGender = 'Female';
            });
          },
          child: CircleAvatar(
            radius: 70,
            backgroundColor: selectedGender == 'Female'
                ? Colors.blue.shade700
                : Colors.grey.shade300,
            child: ClipOval(
              child: Image.asset(
                'assets/female.gif',
                width: 135,
                height: 135,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelect({
    required String label,
    required List<String> options,
    required List<String> selectedItems,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue.shade700),
        ),
        SizedBox(height: 8),
        Column(
          children: options.map((option) {
            return CheckboxListTile(
              title: Text(option, style: TextStyle(fontSize: 14)), // Decreased font size
              value: selectedItems.contains(option),
              onChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
                    selectedItems.add(option);
                  } else {
                    selectedItems.remove(option);
                  }
                  onChanged(selectedItems);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFoodItemsInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Food Items Recommended (if any):',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue.shade700),
        ),
        SizedBox(height: 8),
        TextField(
          controller: foodItemsController,
          decoration: InputDecoration(
            labelText: 'Enter Food Item',
            prefixIcon: Icon(Icons.local_dining, color: Colors.blue.shade700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.blue.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.blue.shade700),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.add, color: Colors.blue.shade700),
              onPressed: () {
                setState(() {
                  if (foodItemsController.text.isNotEmpty) {
                    foodItemsList.add(foodItemsController.text);
                    foodItemsController.clear();
                  }
                });
              },
            ),
          ),
          onSubmitted: (value) {
            setState(() {
              if (value.isNotEmpty) {
                foodItemsList.add(value);
                foodItemsController.clear();
              }
            });
          },
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: foodItemsList.map((item) {
            return Chip(
              label: Text(item, style: TextStyle(fontSize: 14)), // Decreased font size
              deleteIcon: Icon(Icons.close, color: Colors.red),
              onDeleted: () {
                setState(() {
                  foodItemsList.remove(item);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
