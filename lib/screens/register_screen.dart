import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();

  final AuthService _authService = AuthService();

  void register() async {
    User? user = await _authService.registerWithEmail(
      emailController.text,
      passwordController.text,
    );
    if (user != null) {
      UserModel newUser = UserModel(
        uid: user.uid,
        email: user.email!,
        role: 'user',
        name: nameController.text.isNotEmpty ? nameController.text : null,
        phone: phoneController.text.isNotEmpty ? phoneController.text : null,
        department:
            departmentController.text.isNotEmpty
                ? departmentController.text
                : null,
        address:
            addressController.text.isNotEmpty ? addressController.text : null,
        semester:
            semesterController.text.isNotEmpty ? semesterController.text : null,
        studentId:
            studentIdController.text.isNotEmpty
                ? studentIdController.text
                : null,
      );

      try {
        await _authService.storeUserData(newUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create account. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
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
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: departmentController,
              decoration: InputDecoration(labelText: "Department"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: semesterController,
              decoration: InputDecoration(labelText: "Semester"),
            ),
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(labelText: "Student ID"),
            ),

            SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: Text("Register")),
            TextButton(
              onPressed:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ),
              child: Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
