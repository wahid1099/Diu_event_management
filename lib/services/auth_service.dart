import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  // Email & Password Sign In
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign-in error: ${e.toString()}");
      return null;
    }
  }

  // Store User Data in Firestore
  Future<void> storeUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      print("Firestore write error: ${e.toString()}");
      rethrow;
    }
  }

  // Email & Password Registration
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        // Create and store user data
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          role: 'user',
        );
        await storeUserData(newUser);
      }
      return user;
    } catch (e) {
      print("Registration error: ${e.toString()}");
      return null;
    }
  }

  // Google Sign In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      print("Google Sign-in error: ${e.toString()}");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
