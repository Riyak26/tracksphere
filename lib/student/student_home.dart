import 'package:flutter/material.dart';
import 'department_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String selectedDept = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: const Color(0xFFF3F4F6),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF3F4F6),
        foregroundColor: Colors.black,
        title: const Text("Select Department"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              const Text(
                "Choose Your Department",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Select your specialization to track your progress and schedules.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 30),

              buildDepartmentCard(
                context,
                code: "IF6K",
                name: "Information Technology",
                image:
                    "https://www.shutterstock.com/shutterstock/photos/1055271440/display_1500/stock-photo-personal-computer-in-office-1055271440.jpg",
                description:
                    "Focus on software development, cloud computing, and data management systems.",
              ),

              buildDepartmentCard(
                context,
                code: "CO6K",
                name: "Computer Engineering",
                image:
                    "https://p0.piqsels.com/preview/690/183/611/code-coding-connection-css.jpg",
                description:
                    "Integration of hardware systems with software protocols and embedded architecture.",
              ),

              buildDepartmentCard(
                context,
                code: "EJ6K",
                name: "Electronic & Telecommunication",
                image:
                    "https://images.unsplash.com/photo-1581092918056-0c4c3acd3789",
                description:
                    "Study of signal processing, wireless communication, and electronic circuitry.",
              ),

              const SizedBox(height: 40),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildDepartmentCard(
    BuildContext context, {
    required String code,
    required String name,
    required String image,
    required String description,
  }) {

    bool active = selectedDept == code;

    return Container(
      margin: const EdgeInsets.only(bottom: 25),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0,4),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Image.network(
              image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Engineering - $code ($name)",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {

                      setState(() {
                        selectedDept = code;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepartmentPage(
                            className: code,
                          ),
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF477A63),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Select",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}