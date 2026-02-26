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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
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
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                  await _auth.signInWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passController.text.trim(),
                  );

                  // ✅ SAFETY CHECK (THIS FIXES YOUR ERROR)
                  if (!mounted) return;

                 Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TeacherHome(),
  ),
);
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message ?? "Login failed"),
                    ),
                  );
                }
              },
              child: const Text("Login"),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  TeacherRegister()),
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
