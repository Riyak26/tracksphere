import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentRegister extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  StudentRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                final name = nameController.text.trim();
                final email = emailController.text.trim().toLowerCase();
                final password = passwordController.text.trim();

                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                  Fluttertoast.showToast(msg: 'All fields are required');
                  return;
                }

                try {
                  // 🔥 STEP 1: Create user in FirebaseAuth
                  UserCredential userCredential =
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  String uid = userCredential.user!.uid;

                  // 🔥 STEP 2: Save student using UID as document ID
                  await FirebaseFirestore.instance
                      .collection('students')
                      .doc(uid)   // ✅ VERY IMPORTANT
                      .set({
                    'uid': uid,
                    'name': name,
                    'email': email,
                    'groupId': '',
                    'submitted_at': Timestamp.now(),
                  });

                  Fluttertoast.showToast(
                      msg: 'Registration successful!');

                  Navigator.pop(context);
                } on FirebaseAuthException catch (e) {
                  Fluttertoast.showToast(
                      msg: e.message ?? "Registration failed");
                } catch (e) {
                  Fluttertoast.showToast(msg: 'Error: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}