import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'teacher_home.dart';
import 'teacher_register.dart';

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({super.key});

  @override
  State<TeacherLogin> createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool showResetField = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    newPassController.dispose();
    super.dispose();
  }

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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TeacherHome()),
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
      // Re-authenticate with current password
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
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  MaterialPageRoute(builder: (_) => TeacherRegister()),
                );
              },
              child: const Text("New Teacher? Register"),
            ),
          ],
        ),
      ),
    );
  }
}