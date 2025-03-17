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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign up',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Create account and enjoy all services',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              SizedBox(height: 32),
              // All TextFields with updated design
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Type your full name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Type your email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Type your password',
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: departmentController,
                decoration: InputDecoration(
                  labelText: "Department",
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: semesterController,
                decoration: InputDecoration(
                  labelText: "Semester",
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: studentIdController,
                decoration: InputDecoration(
                  labelText: "Student ID",
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or continue with',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Google sign in logic
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                    ),
                    child: Image.asset(
                      'assets/icons/google_login.png',
                      height: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
