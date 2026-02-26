import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'teacher_home.dart';

class TeacherRegister extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Teacher Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: "Email"),
            ),
            TextField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(hintText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passController.text.trim(),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => TeacherHome()),
                  );
                } on FirebaseAuthException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message ?? "Registration failed")),
                  );
                }
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}