import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget feature(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(icon, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget member(String name) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(name)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TrackSphere"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// OUR MISSION
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Mission",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                      "TrackSphere is a Flutter-based mobile application designed "
                      "to manage Final Year Projects efficiently in academic institutions. "
                      "Students can register, create project groups, and submit project "
                      "details. Guides evaluate projects and provide remarks while "
                      "HODs monitor submissions and evaluations."),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// FEATURES
            const Text(
              "Key Features",
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            feature(
              Icons.show_chart,
              "Real-time Tracking",
              "Monitor project milestones and progress easily.",
            ),

            feature(
              Icons.group,
              "Seamless Collaboration",
              "Communication between students and guides.",
            ),

            feature(
              Icons.folder,
              "Resource Management",
              "Manage project files and documentation.",
            ),

            const SizedBox(height: 20),

            /// TEAM
            const Text(
              "Development Team",
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Column(
                  children: [
                    CircleAvatar(child: Icon(Icons.person)),
                    SizedBox(height: 5),
                    Text("Ishita Raje")
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(child: Icon(Icons.person)),
                    SizedBox(height: 5),
                    Text("Arya Khedekar")
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Column(
                  children: [
                    CircleAvatar(child: Icon(Icons.person)),
                    SizedBox(height: 5),
                    Text("Punita Wadkar")
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(child: Icon(Icons.person)),
                    SizedBox(height: 5),
                    Text("Shravani Nirmal")
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}