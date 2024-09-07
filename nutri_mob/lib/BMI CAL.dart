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
  var bgColor = Colors.blue.shade50;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  List<String> diseases = [
    'Diabetes',
    'Cardiovascular Diseases',
    'Lactose Intolerance',
    'Osteoporosis',
    'None' // Added "None" option
  ];

  List<String> allergies = [
    'Dust mites',
    'Food allergies',
    'Certain chemicals',
    'Latex',
    'Medication',
    'None' // Added "None" option
  ];

  String? selectedGender = 'None';
  String? selectedDisease = 'None';
  String? selectedAllergy = 'None';

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
            fontFamily: 'Lexend',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20, // Adjust the font size as needed
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Lexend',
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Lexend',
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Lexend',
            color: Colors.black,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Enter Your Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                    _buildGenderSelection(),
                    SizedBox(height: 16),
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
                    _buildDropdownMenu(
                      label: 'Select Disease (if any):',
                      value: selectedDisease,
                      items: diseases,
                      onChanged: (newValue) {
                        setState(() {
                          selectedDisease = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildDropdownMenu(
                      label: 'Select Allergies (if any):',
                      value: selectedAllergy,
                      items: allergies,
                      onChanged: (newValue) {
                        setState(() {
                          selectedAllergy = newValue;
                        });
                      },
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
                        var dob = selectedDateOfBirth;
                        var allergies = selectedAllergy;
                        var foodItems = foodItemsController.text.toString();

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

                            if (allergies != null && allergies != 'None') {
                              userData["allergies"] = allergies;
                            }
                            if (foodItems.isNotEmpty) {
                              userData["food_items_recommended"] = foodItems;
                            }
                            if (selectedDisease != null && selectedDisease != 'None') {
                              userData["selected_disease"] = selectedDisease;
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
                            result =
                            "Please fill all the required fields!";
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 24.0),
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedGender = 'Male';
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedGender == 'Male'
                    ? Colors.blue.shade700
                    : Colors.grey,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 40, // Adjust size as needed
              backgroundImage: AssetImage('assets/male.gif'), // Add your male image asset
            ),
          ),
        ),
        SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedGender = 'Female';
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedGender == 'Female'
                    ? Colors.blue.shade700
                    : Colors.grey,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 40, // Adjust size as needed
              backgroundImage: AssetImage('assets/female.gif'), // Add your female image asset
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownMenu({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
        ),
        DropdownButton<String>(
          value: value,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(
            'Select',
            style: TextStyle(color: Colors.blue.shade700),
          ),
        ),
      ],
    );
  }
}
