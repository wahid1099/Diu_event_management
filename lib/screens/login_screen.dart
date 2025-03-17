import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../services/auth_service.dart';
import '../screens/admin/admin_dashboard.dart'; // Import your admin dashboard
import "../screens/register_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void login() async {
    User? user = await _authService.signInWithEmail(
      emailController.text,
      passwordController.text,
    );
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      ); // Change to respective dashboard
    }
  }

  void loginWithGoogle() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboard()),
      ); // Change to respective dashboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text("Login")),
            OutlinedButton.icon(
              icon: Icon(Icons.login),
              label: Text("Login with Google"),
              onPressed: loginWithGoogle,
            ),
            TextButton(
              onPressed:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  ),
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
