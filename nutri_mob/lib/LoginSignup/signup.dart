import 'package:flutter/material.dart';
import 'package:nutri_mob/LoginSignup/Services/authentication.dart';
import 'package:nutri_mob/LoginSignup/SlidingPages.dart';
import 'package:nutri_mob/LoginSignup/Widget/snack_bar.dart';
import 'login.dart';
import 'Widget/text_field.dart'; // Ensure this file exists and is correctly implemented
import 'Widget/button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  void depose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthServices().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );
    if (res == "Success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SlidingPages(),//LoginScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  void signUp() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SlidingPages(),//LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height / 2.8,
                  child: Image.asset("assets/SignUp.png"),
                ),
                TextFieldInput(
                  textEditingController: nameController,
                  hintText: "Enter your name",
                  icon: Icons.person,
                  obscureText: false,
                ),
                TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                  obscureText: false,
                ),
                TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Enter your password",
                  isPass: true,
                  icon: Icons.lock,
                  obscureText: true,
                ),
                MyButton(
                  //onTap: signUpUser,
                  onTap: signUp,
                  text: "Sign Up",
                  isLoading: isLoading,
                ),
                SizedBox(
                  height: height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
