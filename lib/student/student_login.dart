import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../first_page.dart';
import 'student_home.dart';
import 'student_register.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  State<StudentLogin> createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final newPassController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool showResetField = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter email and password")),
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    }
  }

  Future<void> changePassword() async {
    if (emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter email")),
      );
      return;
    }

    if (passController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter current password")),
      );
      return;
    }

    if (newPassController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter new password")),
      );
      return;
    }

    if (newPassController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("New password must be at least 6 characters")),
      );
      return;
    }

    try {
      // Re-login to verify current password
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      User? user = credential.user;

      await user!.updatePassword(newPassController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully")),
      );

      setState(() {
        showResetField = false;
        newPassController.clear();
      });

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error occurred")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const FirstPage()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(hintText: "Password"),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showResetField = true;
                    });
                  },
                  child: const Text("Forgot Password?"),
                ),
              ),

              if (showResetField) ...[
                TextField(
                  controller: newPassController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: "Enter New Password"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: changePassword,
                  child: const Text("Save New Password"),
                ),
              ],

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => StudentRegister()),
                  );
                },
                child: const Text("New Student? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}