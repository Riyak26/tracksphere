import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../first_page.dart';
import '../teacher/marksheet_page.dart';

class StudentMarksheetLogin extends StatefulWidget {
  const StudentMarksheetLogin({super.key});

  @override
  State<StudentMarksheetLogin> createState() => _StudentMarksheetLoginState();
}

class _StudentMarksheetLoginState extends State<StudentMarksheetLogin> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool loading = false;

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
          title: const Text("View Marksheet"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const FirstPage()),
                (route) => false,
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: loginAndOpenMarksheet,
                      child: const Text("View Marksheet"),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginAndOpenMarksheet() async {
    setState(() => loading = true);

    try {
      /// 1️⃣ Login
      UserCredential cred =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      final uid = cred.user!.uid;

      /// 2️⃣ Get student document
      final studentSnap = await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get();

      if (!studentSnap.exists) {
        throw "Student record not found";
      }

      /// 3️⃣ Read groupId
      final groupId = studentSnap['groupId'] as String;

      /// 4️⃣ Open Marksheet (❗ NO const)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MarksheetPage(groupId: groupId),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }
}