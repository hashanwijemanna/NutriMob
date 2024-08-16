import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutri_mob/LoginSignup/PasswordForgot/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Nothing to worry!",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(
                width: 240,
                height: 240,
                child: Image.asset(
                  'assets/question.gif',
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  myDialogBox(context);
                },
                child: const Text(
                  "Click Here",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.blue,
                  ),
                ),
              ),
              Text(
                "Enter your Email address and check your Email inbox for password reset link.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


void myDialogBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    "Forgot Your Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(onPressed: () {
                    Navigator.pop(context);
                  },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter the Email",
                  hintText: "abc@gmail.com",
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: () async {
                  await auth
                      .sendPasswordResetEmail(email: emailController.text)
                      .then((value) {
                        showSnackBar(context, "We have send you the rest password link. Please check your Email inbox");
                  }).onError((error, stackTrace) {
                    showSnackBar(context, error.toString());
                  });
                  Navigator.pop(context);
                  emailController.clear();
                },


                  child: Text(
                    "Send",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
