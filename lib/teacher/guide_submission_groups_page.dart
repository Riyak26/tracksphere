import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'guide_files_page.dart';

class GuideSubmissionGroupsPage extends StatelessWidget {
  final String guideId;

  const GuideSubmissionGroupsPage({super.key, required this.guideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Submissions")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('submissions')
            .where('guideId', isEqualTo: guideId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final groups = snapshot.data!.docs
              .map((doc) => doc['groupId'] as String)
              .toSet()
              .toList();

          if (groups.isEmpty) {
            return const Center(child: Text("No submissions yet"));
          }

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text("Group ${groups[index]}"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GuideFilesPage(
                          guideId: guideId,
                          groupId: groups[index],
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