import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hod_dashboard.dart';
import 'package:demo/first_page.dart';

class HodAuthPage extends StatefulWidget {
  const HodAuthPage({super.key});

  @override
  State<HodAuthPage> createState() => _HodAuthPageState();
}

class _HodAuthPageState extends State<HodAuthPage> {

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final newPassController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool hidePassword = true;
  bool showResetField = false;
  bool isLoading = false;

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
        MaterialPageRoute(builder: (_) => const HodDashboard()),
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
        const SnackBar(content: Text("Enter old password")),
      );
      return;
    }

    if (newPassController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter new password")),
      );
      return;
    }

    try {

      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      User? user = userCredential.user;

      AuthCredential credential = EmailAuthProvider.credential(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      await user!.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassController.text.trim());

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

  Widget inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffix,
  }) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          obscureText: obscure,

          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color(0xFFF4F4F4),

            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF6F6F6),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 10),

                /// BACK BUTTON + TITLE
                Row(
                  children: [

                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FirstPage()),
                        );
                      },
                    ),

                    const Text(
                      "TrackSphere",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Container(

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 10,
                            offset: const Offset(0,4)
                        )
                      ]
                  ),

                  child: Column(

                    children: [

                      /// HOD LOGIN INSIDE BOX
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "HOD Login",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      inputField(
                        label: "Email Address",
                        hint: "e.g. hod@gmail.com",
                        controller: emailController,
                      ),

                      const SizedBox(height: 20),

                      inputField(
                        label: "Password",
                        hint: "Enter your password",
                        controller: passController,
                        obscure: hidePassword,
                        suffix: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: (){
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(

                          onPressed: (){
                            setState(() {
                              showResetField = true;
                            });
                          },

                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                                color: Color(0xFF4E7D6B),
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),

                      if(showResetField) ...[

                        inputField(
                          label: "New Password",
                          hint: "Enter new password",
                          controller: newPassController,
                          obscure: true,
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 50,

                          child: ElevatedButton(

                            onPressed: changePassword,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4E7D6B),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                              ),
                            ),

                            child: const Text(
                              "Save New Password",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton(

                          onPressed: login,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4E7D6B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)
                            ),
                          ),

                          child: const Text(
                            "Login to Portal",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}