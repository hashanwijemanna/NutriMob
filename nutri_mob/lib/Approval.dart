import 'package:flutter/material.dart';

class ApprovalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Approval',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF00B2A9),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Approved by Dr. W.W.S.W.C. Fernando',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
              Text(
                'Medical Doctor & Consultant Dietitian\nMBBS(SL)(COL)MSC.(FSc)\nRegistraion Number: 10629\nContact nu: +94718371603',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              // Image with round background color
              Stack(
                alignment: Alignment.center,
                children: [
                  // Rounded background
                  Container(
                    width: screenWidth * 0.6,
                    height: screenWidth * 0.6,
                  ),
                  // Image overlay
                  Image.asset(
                    'assets/approval.png',
                    height: 400,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
