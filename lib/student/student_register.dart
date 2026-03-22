import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentRegister extends StatefulWidget {
  const StudentRegister({super.key});

  @override
  State<StudentRegister> createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text("Create Account"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              /// TITLE
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Join TrackSphere to start tracking your progress today.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              /// FULL NAME
              const Text(
                "Full Name",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your full name",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// EMAIL
              const Text(
                "Email Address",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "name@example.com",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              const Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// TERMS TEXT
              RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                  children: [
                    TextSpan(
                        text:
                        "By creating an account, you agree to TrackSphere’s "),
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: Colors.green),
                    ),
                    TextSpan(text: "."),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// CREATE ACCOUNT BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F7D57),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    "Create My Account",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  onPressed: () async {

                    final name = nameController.text.trim();
                    final email = emailController.text.trim().toLowerCase();
                    final password = passwordController.text.trim();

                    if (name.isEmpty || email.isEmpty || password.isEmpty) {
                      Fluttertoast.showToast(msg: 'All fields are required');
                      return;
                    }

                    try {

                      UserCredential userCredential =
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      String uid = userCredential.user!.uid;

                      await FirebaseFirestore.instance
                          .collection('students')
                          .doc(uid)
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
              ),

              const SizedBox(height: 20),

              /// BACK TO LOGIN
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Back to Login",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),

              const SizedBox(height: 40),

            ],
          ),
        ),
      ),
    );
  }
}