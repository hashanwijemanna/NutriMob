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
  List<String> foodItemsList = [];

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
    'Peanuts',
    'Soy',
    'Mustard',
    'Gluten',
    'Corn',
  ];

  List<String> selectedDiseases = [];
  List<String> selectedAllergies = [];

  String? selectedGender = 'None';
  String? dietaryPreference = 'veg';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lexend',
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Enter Your Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _buildGenderSelection(),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: wtController,
                      label: 'Weight (in Kgs)',
                      icon: Icons.line_weight,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: htController,
                      label: 'Height (in centimeters)',
                      icon: Icons.height,
                    ),
                    SizedBox(height: 20),
                    _buildDatePicker(),
                    SizedBox(height: 20),
                    _buildDietaryPreference(),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    if (dietaryPreference == 'Non-Veg') ...[
                      _buildFoodItemsInput(),
                      SizedBox(height: 20),
                    ],
                    // Inside the Column widget
                    Center(
                      child: ElevatedButton(
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

                              // Create the userData map including all the selected details
                              Map<String, dynamic> userData = {
                                "weight": iWt,
                                "height": iht,
                                "date_of_birth": dob.toIso8601String(),
                                "bmi": bmi.toStringAsFixed(2),
                                "email": email,
                                "gender": selectedGender,
                                "dietary_preference": dietaryPreference,  // Add dietary preference here
                              };

                              if (selectedAllergies.isNotEmpty) {
                                userData["allergies"] = selectedAllergies.join(', ');
                              }
                              if (dietaryPreference == 'Non-Veg' && foodItems.isNotEmpty) {
                                userData["food_items_recommended"] = foodItems;
                              }
                              if (selectedDiseases.isNotEmpty) {
                                userData["selected_disease"] = selectedDiseases.join(', ');
                              }

                              DatabaseReference userRef = _database.ref("users/${user.uid}");

                              // Store bioData in Firebase
                              await userRef.child("bioData").set(userData);

                              // Store BMI record with a timestamp
                              String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
                              await userRef.child("bmiRecords").child(timestamp).set({
                                "bmi": bmi.toStringAsFixed(2),
                                "date": DateTime.now().toIso8601String(),
                              });

                              // Navigate to the home screen after data submission
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
                          backgroundColor: Colors.green,
                          disabledBackgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                            'Submit',
                          style: TextStyle(
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(
                      result,
                      style: TextStyle(
                        fontSize: 14,
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue.shade700),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                selectedDateOfBirth == null
                    ? 'Select Date of Birth'
                    : 'Date of Birth: ${selectedDateOfBirth!.toLocal().toString().split(' ')[0]}',
                style: TextStyle(fontSize: 14),
              ),
              trailing: Icon(Icons.calendar_today, color: Colors.blue.shade700),
              onTap: () async {
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
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text('Gender', style: TextStyle(fontSize: 16)),
            ),
          ),
          CircleAvatar(
            backgroundColor:
            selectedGender == 'Male' ? Colors.blue.shade700 : Colors.grey,
            child: IconButton(
              icon: Icon(Icons.male),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  selectedGender = 'Male';
                });
              },
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor:
            selectedGender == 'Female' ? Colors.blue.shade700 : Colors.grey,
            child: IconButton(
              icon: Icon(Icons.female),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  selectedGender = 'Female';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryPreference() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text('Dietary Preference', style: TextStyle(fontSize: 16)),
              subtitle: Text(
                dietaryPreference!,
                style: TextStyle(fontSize: 14, color: Colors.blue.shade700),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  setState(() {
                    dietaryPreference = value;
                  });
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'veg', child: Text('Vegetarian')),
                  PopupMenuItem(value: 'non-veg', child: Text('Non-Vegetarian')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelect({
    required String label,
    required List<String> options,
    required List<String> selectedItems,
    required void Function(List<String>) onChanged,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: options.map((option) {
              return FilterChip(
                selected: selectedItems.contains(option),
                label: Text(option),
                selectedColor: Colors.blue.shade700,
                backgroundColor: Colors.grey.shade200,
                onSelected: (isSelected) {
                  setState(() {
                    if (isSelected) {
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
      ),
    );
  }

  Widget _buildFoodItemsInput() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Food Items Recommended:',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextField(
            controller: foodItemsController,
            decoration: InputDecoration(
              hintText: 'Enter food items',
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onSubmitted: (value) {
              setState(() {
                foodItemsList.add(value);
                foodItemsController.clear();
              });
            },
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: foodItemsList.map((item) {
              return Chip(
                label: Text(item),
                onDeleted: () {
                  setState(() {
                    foodItemsList.remove(item);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
