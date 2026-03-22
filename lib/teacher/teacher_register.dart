import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'teacher_home.dart';

class TeacherRegister extends StatefulWidget {
  const TeacherRegister({super.key});

  @override
  State<TeacherRegister> createState() => _TeacherRegisterState();
}

class _TeacherRegisterState extends State<TeacherRegister> {

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool hidePassword = true;

  Widget inputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
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
            prefixIcon: icon != null ? Icon(icon) : null,
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color(0xFFF4F4F4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF6F6F6),

      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const SizedBox(height: 10),

              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              const Text(
                "TrackSphere",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Join TrackSphere to start tracking your progress today.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54
                ),
              ),

              const SizedBox(height: 30),

              /// Full Name
              inputField(
                label: "Full Name",
                hint: "John Doe",
                controller: nameController,
                icon: Icons.person_outline,
              ),

              /// Email
              inputField(
                label: "Email Address",
                hint: "jon.doe@gmail.com",
                controller: emailController,
                icon: Icons.email_outlined,
              ),

              /// Password
              inputField(
                label: "Password",
                hint: "Enter password",
                controller: passController,
                icon: Icons.lock_outline,
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

              /// Register Button
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E6E5E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)
                    ),
                  ),

                  onPressed: () async {

                    try {

                      UserCredential userCredential =
                          await _auth.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passController.text.trim(),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => TeacherHome()),
                      );

                    } on FirebaseAuthException catch (e) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(e.message ?? "Registration failed"),
                        ),
                      );
                    }
                  },

                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Login Text
              Center(
                child: TextButton(

                  onPressed: (){
                    Navigator.pop(context);
                  },

                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: Color(0xFF3E6E5E),
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}