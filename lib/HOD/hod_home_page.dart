import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hod_group_page.dart';

class HodHomePage extends StatelessWidget {
  const HodHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOD Dashboard"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final groups = snapshot.data!.docs;

          if (groups.isEmpty) {
            return const Center(child: Text("No Groups Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              var group = groups[index];
              String groupId = group.id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(group['className'],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),

                      const SizedBox(height: 5),

                      Text("Domain: ${group['domain']}"),

                      const SizedBox(height: 15),

                      /// PROGRESS
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('submissions')
                            .where('groupId', isEqualTo: groupId)
                            .snapshots(),
                        builder: (context, subSnap) {

                          int total = 6;
                          int uploaded = subSnap.hasData
                              ? subSnap.data!.docs.length
                              : 0;

                          double progress = uploaded / total;

                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text("Project Progress"),
                              const SizedBox(height: 5),
                              LinearProgressIndicator(
                                  value: progress),
                              const SizedBox(height: 5),
                              Text(
                                  "$uploaded of $total uploaded (${(progress * 100).toInt()}%)"),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 15),

                     Wrap(
  spacing: 6, // reduced space
  runSpacing: 6,
  children: [

    _chip(context, "Students Details", groupId, 0),

    _chip(context, "Submission", groupId, 1),

    _chip(context, "Marks Evaluation", groupId, 2),

    _chip(context, "Marksheet", groupId, 3),

    /// ✅ APPROVE BUTTON ADDED HERE
    StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .snapshots(),
      builder: (context, snap) {

        bool isApproved = false;

        if (snap.hasData && snap.data!.exists) {
          final data =
              snap.data!.data() as Map<String, dynamic>;
          isApproved = data['approved'] ?? false;
        }

        return ActionChip(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 0),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isApproved)
                const Icon(Icons.check,
                    size: 16, color: Colors.green),
              if (isApproved)
                const SizedBox(width: 4),
              Text(isApproved ? "Approved" : "Approve"),
            ],
          ),
          onPressed: isApproved
              ? null
              : () async {
                  await FirebaseFirestore.instance
                      .collection('groups')
                      .doc(groupId)
                      .set(
                    {'approved': true},
                    SetOptions(merge: true),
                  );

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content:
                          Text("Project Approved Successfully"),
                    ),
                  );
                },
        );
      },
    ),
  ],
)
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _chip(BuildContext context,
      String title, String groupId, int index) {
    return ActionChip(
      label: Text(title),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                HodGroupPage(groupId: groupId, index: index),
          ),
        );
      },
    );
  }
}