import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final DatabaseReference _feedbackRef = FirebaseDatabase.instance.reference().child('feedbacks');

  // Method to submit feedback
  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      final feedback = _feedbackController.text;
      final email = _emailController.text;

      // Save feedback to Firebase
      _feedbackRef.push().set({
        'email': email,
        'feedback': feedback,
        'timestamp': DateTime.now().toIso8601String(),
      }).then((_) {
        // Clear the input fields after submission
        _feedbackController.clear();
        _emailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: Colors.green,
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to submit feedback: $error'),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Lexend',
          ),
        ),
        backgroundColor: Color(0xFF00B2A9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Centered Image
              Center(
                child: Image.asset(
                  'assets/feedback.png', // Ensure the path matches your assets folder
                  height: 200, // You can adjust the height to suit your design
                  width: 200,
                ),
              ),
              Text(
                'We highly value your feedback.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00B2A9),
                  fontFamily: 'Lexend',
                ),
              ),
              SizedBox(height: 20), // Spacing between the image and the form

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00B2A9),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Enter your email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Your Feedback',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00B2A9),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _feedbackController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Enter your feedback',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Feedback is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00B2A9),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Submit Feedback',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
