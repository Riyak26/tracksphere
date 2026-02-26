import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HodFilesPage extends StatelessWidget {
  final String groupId;

  const HodFilesPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(child: Text("No Data Found"));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          List members = data['members'] ?? [];

          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              var student = members[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(student['name']),
                subtitle: Text("Roll No: ${student['rollNo']}"),
              );
            },
          );
        },
      ),
    );
  }
}