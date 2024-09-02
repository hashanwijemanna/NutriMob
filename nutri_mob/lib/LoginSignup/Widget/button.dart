import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isLoading;
  final Gradient? gradient; // Add this line

  const MyButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
    this.gradient, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: gradient ?? const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          text,
          style: GoogleFonts.lexend(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
