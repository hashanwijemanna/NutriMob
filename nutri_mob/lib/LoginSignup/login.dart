import 'package:flutter/material.dart';
import 'package:nutri_mob/LoginSignup/PasswordForgot/forgot_password.dart';
import 'package:nutri_mob/LoginSignup/Services/authentication.dart';
import 'package:nutri_mob/LoginSignup/Widget/button.dart';
import 'package:nutri_mob/LoginSignup/Widget/snack_bar.dart';
import 'package:nutri_mob/LoginSignup/Widget/text_field.dart';
import 'package:nutri_mob/home.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUsers() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    if (res == "Success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  void signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    User? user = await AuthServices().signInWithGoogle();
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Google Sign-In failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: height / 2.7,
              child: Image.asset("assets/Login.png"),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFieldInput(
                      textEditingController: emailController,
                      hintText: "Enter your email",
                      icon: Icons.email,
                      obscureText: false,
                    ),
                    TextFieldInput(
                      isPass: true,
                      textEditingController: passwordController,
                      hintText: "Enter your password",
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    MyButton(
                      onTap: loginUsers,
                      text: "Log In",
                      isLoading: isLoading,
                    ),
                    SizedBox(
                      height: height / 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            " Sign Up",
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: signInWithGoogle,
                child: Image.asset('assets/google_logo.png', height: 70), // Use your image path here
              ),
            ),
          ],
        ),
      ),
    );
  }
}
