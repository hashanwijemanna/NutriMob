import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_mob/LoginSignup/signup.dart'; // Import your SignUpScreen here
import 'package:nutri_mob/LoginSignup/login.dart'; // Import your LoginScreen here

void main() {
  runApp(ConditionsApp());
}

class ConditionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConditionPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.lexendTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.black87,
            displayColor: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class ConditionPage extends StatefulWidget {
  @override
  _ConditionPageState createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  bool _isAgreeButtonEnabled = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _isAgreeButtonEnabled = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Before You Proceed',
                  style: GoogleFonts.lexend(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                'Please read and understand the following conditions:',
                textAlign: TextAlign.center,
                style: GoogleFonts.lexend(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 30),
            _buildConditionExplanation(
              title: "Health Awareness",
              description: "Be aware of your current health status and take responsibility for your well-being. The app provides complementary information to professional medical advice.",
            ),
            _buildConditionExplanation(
              title: "True Information",
              description: "Provide accurate and truthful information. The app relies on the integrity of the data you provide to function effectively and offer accurate insights.",
            ),
            _buildConditionExplanation(
              title: "Terms and Conditions",
              description: "By using this app, you agree to follow the rules, regulations, and policies set by the developers. Familiarize yourself with these guidelines for proper app usage.",
            ),
            _buildConditionExplanation(
              title: "Data Privacy",
              description: "We value your privacy. Your data will be handled according to our privacy policy, ensuring that your information is secure and used only for intended purposes.",
            ),
            _buildConditionExplanation(
              title: "Use Responsibility",
              description: "Use the app in a manner consistent with its purpose. Misuse can lead to inaccurate results or potential harm.",
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(), // Redirects to LoginScreen
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: GoogleFonts.lexend(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _isAgreeButtonEnabled ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUpScreen(), // Redirects to SignUpScreen
                      ),
                    );
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAgreeButtonEnabled ? Colors.teal : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: GoogleFonts.lexend(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Agree'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionExplanation({
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.lexend(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.lexend(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
