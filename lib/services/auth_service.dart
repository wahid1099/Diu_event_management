import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _uidKey = 'uid';

  // Email & Password Sign In
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        await saveUID(result.user!.uid);
      }
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
      throw Exception('Failed to store user data: ${e.toString()}');
    }
  }

  // Email & Password Registration
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        await saveUID(result.user!.uid);
      }
      return result.user;
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

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken!,
        idToken: googleAuth.idToken!,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      if (result.user != null) {
        await saveUID(result.user!.uid);
      }
      return result.user;
    } catch (e) {
      print("Google Sign-in error: ${e.toString()}");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await clearUID();
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print("Sign-out error: ${e.toString()}");
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  // Save UID to SharedPreferences
  static Future<void> saveUID(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_uidKey, uid);
    } catch (e) {
      print("Error saving UID: ${e.toString()}");
      throw Exception('Failed to save UID: ${e.toString()}');
    }
  }

  // Get saved UID
  static Future<String?> getUID() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_uidKey);
    } catch (e) {
      print("Error getting UID: ${e.toString()}");
      return null;
    }
  }

  // Clear saved UID (for logout)
  static Future<void> clearUID() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_uidKey);
    } catch (e) {
      print("Error clearing UID: ${e.toString()}");
      throw Exception('Failed to clear UID: ${e.toString()}');
    }
  }
}
