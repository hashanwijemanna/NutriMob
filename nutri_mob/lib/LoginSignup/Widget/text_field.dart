import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final bool isPass;
  final Color? backgroundColor;

  const TextFieldInput({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    required this.icon,
    required this.obscureText,
    this.isPass = false,
    this.backgroundColor, // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: textEditingController,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: backgroundColor ?? Colors.grey[200], // Use backgroundColor if provided
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: GoogleFonts.lexend(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
