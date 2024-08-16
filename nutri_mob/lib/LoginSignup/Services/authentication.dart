import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // For storing data in Cloud Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // For authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // For Sign Up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      // For registering user in Firebase Auth with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // For adding user to our Cloud Firestore
      await _firestore.collection("users").doc(credential.user!.uid).set(
        {
          'name': name,
          'email': email,
          'uid': credential.user!.uid,
        },
      );
      res = "Success";
    } catch (e) {
      return e.toString();
    }
    return res;
  }
  //for login screen
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = " Some error Occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty){
        // login user with email and password
        await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
        );
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    }catch(e){
      return e.toString();
    }
    return res;
  }
}
