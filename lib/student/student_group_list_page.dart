import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'document_status_page.dart';
import 'package:demo/teacher/guide_submission_files_page.dart';

class StudentGroupListPage extends StatelessWidget {
  const StudentGroupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    // 🔥 DEBUG (check in terminal)
    print("Logged in Student UID: ${user.uid}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Group"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where('studentUid', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No group assigned"));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                    data['projectTitle'] ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${data['className']} - ${data['section']}",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    print("Opening groupId: ${doc.id}"); // 🔥 DEBUG

                  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => GuideSubmissionFilesPage(
      groupId: doc.id,   // 🔥 MUST BE doc.id
    ),
  ),
);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}