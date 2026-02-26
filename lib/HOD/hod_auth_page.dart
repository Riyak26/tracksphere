import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hod_dashboard.dart';
import 'package:demo/first_page.dart'; // 👈 CHANGE this to your first page file

class HodAuthPage extends StatefulWidget {
  const HodAuthPage({super.key});

  @override
  State<HodAuthPage> createState() => _HodAuthPageState();
}

class _HodAuthPageState extends State<HodAuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  Future<void> authenticate() async {
    try {
      setState(() => isLoading = true);

      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        UserCredential user =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .set({
          'email': emailController.text.trim(),
          'role': 'hod',
        });
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HodDashboard(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "HOD Login" : "HOD Register"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const FirstPage(), // 👈 CHANGE to your first page class
              ),
              (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 25),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: authenticate,
                    child: Text(isLogin ? "Login" : "Register"),
                  ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                  isLogin ? "Create account" : "Already have account"),
            ),
          ],
        ),
      ),
    );
  }
}