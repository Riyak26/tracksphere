import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TrackSphere"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Help & Support",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Find answers to common questions about the TrackSphere FYP Management system.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              const Text(
                "COMMON QUESTIONS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 10),

              /// Question 1
              Card(
                child: ExpansionTile(
                  title: const Text("How to register?"),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "To register click on the register then fill the given detail and click Create my account your account will be created.",
                      ),
                    )
                  ],
                ),
              ),

              /// Question 2
              Card(
                child: ExpansionTile(
                  title: const Text("How to submit a project?"),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "The steps to submit the project is first you should login in then select the department and the section after that submit you group and you will be able to submit the project in the enroll grp page there is drop down menu in that you can choose and submit the reports.",
                      ),
                    )
                  ],
                ),
              ),

              /// Question 3
              Card(
                child: ExpansionTile(
                  title: const Text("How to reset my password?"),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "In case you have to change the password there is option of forget password in the login page itself enter your email and old credential add new password and click reset password.",
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}