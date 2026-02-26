import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectProgressWidget extends StatelessWidget {
  final String groupId;

  const ProjectProgressWidget({
    super.key,
    required this.groupId,
  });

  final int totalRequiredDocs = 5; // 🔥 CHANGED FROM 6 TO 5

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('submissions')
          .where('groupId', isEqualTo: groupId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: LinearProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Text("Error loading progress");
        }

        int uploadedDocs = snapshot.data?.docs.length ?? 0;

        double progress =
            (uploadedDocs / totalRequiredDocs).clamp(0.0, 1.0);

        int percent = (progress * 100).toInt();

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 6,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Project Progress",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  percent == 100
                      ? const Color.fromARGB(255, 75, 128, 77)
                      : const Color.fromARGB(255, 88, 146, 96),
                ),
              ),
              const SizedBox(height: 8),

              // ✅ NOW SHOWS 0/5, 1/5, etc.
              Text(
                "$uploadedDocs/$totalRequiredDocs",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}