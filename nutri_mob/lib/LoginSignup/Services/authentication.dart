import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // Firestore instance for storing data in Cloud Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FirebaseAuth instance for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // GoogleSignIn instance for Google authentication
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Method for signing up a user with email, password, and name
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      // Register user with Firebase Auth using email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Cloud Firestore
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': credential.user!.uid,
      });

      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Method for logging in a user with email and password
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Log in user with Firebase Auth using email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // Method for signing in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

        // Add user details to Cloud Firestore if it's a new user
        if (userCredential.additionalUserInfo!.isNewUser) {
          await _firestore.collection("users").doc(userCredential.user!.uid).set({
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'uid': userCredential.user!.uid,
          });
        }

        return userCredential.user;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Method for signing out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
