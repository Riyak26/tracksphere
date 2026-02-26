import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../teacher/marksheet_page.dart';

class StudentLoginRedirect extends StatelessWidget {
  const StudentLoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Student not assigned to group")),
          );
        }

        final groupId = snapshot.data!['groupId'];

        return MarksheetPage(groupId: groupId);
      },
    );
  }
}