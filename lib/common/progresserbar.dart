import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectProgressWidget extends StatelessWidget {
  final String groupId;

  // Fixed to 5 documents only
  static const int totalRequiredDocs = 5;

  const ProjectProgressWidget({
    super.key,
    required this.groupId,
  });

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

        // Count uploaded PDFs
        int uploadedDocs = snapshot.data?.docs.length ?? 0;

        // Limit max to 5
        if (uploadedDocs > totalRequiredDocs) {
          uploadedDocs = totalRequiredDocs;
        }

        // Calculate progress out of 5
        double progress = uploadedDocs / totalRequiredDocs;

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
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 88, 146, 96),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "$uploadedDocs of $totalRequiredDocs uploaded ($percent%)",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }
}