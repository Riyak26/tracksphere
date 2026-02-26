import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HodStudentsPage extends StatelessWidget {
  final String groupId;

  const HodStudentsPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Students Details")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .where('groupId', isEqualTo: groupId)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs;

          if (students.isEmpty) {
            return const Center(
                child: Text("No Students Found"));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var s = students[index];

              return ListTile(
                title: Text(s['name']),
                subtitle:
                    Text("Roll No: ${s['rollNo']}"),
              );
            },
          );
        },
      ),
    );
  }
}