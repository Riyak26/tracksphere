import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> changePassword() async {

    if(emailController.text.isEmpty || newPasswordController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields"))
      );
      return;
    }

    try{

      User? user = _auth.currentUser;

      if(user == null){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in"))
        );
        return;
      }

      /// update password
      await user.updatePassword(newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password changed successfully"))
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Error"))
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Change Password"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 30),

            /// EMAIL
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// NEW PASSWORD
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: changePassword,

                child: const Text("Update Password"),
              ),
            )

          ],
        ),
      ),
    );
  }
}