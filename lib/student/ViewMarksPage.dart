import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewMarksPage extends StatelessWidget {
  final String email;

  ViewMarksPage({super.key, required this.email});

  final List<String> formative = [
    "Topic Selection",
    "Literature Review",
    "Quality of Preparation",
    "Q&A Handling",
    "Time Management",
    "Seminar Report",
  ];

  final List<String> summative = [
    "Quality of Information",
    "Creativity & Innovation",
    "Response to Questions",
    "Problem Statement",
    "Objectives & Action Plan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Marks')),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('groups')
            .where('studentEmail', isEqualTo: email)
            .limit(1)
            .get(),
        builder: (context, groupSnapshot) {
          if (!groupSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (groupSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("You are not assigned to any group"),
            );
          }

          final groupData =
              groupSnapshot.data!.docs.first.data() as Map<String, dynamic>;

          final String groupId = groupData['groupId'];

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('marks')
                .doc(groupId)
                .snapshots(),
            builder: (context, marksSnapshot) {
              if (!marksSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!marksSnapshot.data!.exists) {
                return const Center(
                  child: Text("Marks not submitted yet"),
                );
              }

              final data =
                  marksSnapshot.data!.data() as Map<String, dynamic>;

              final Map<String, dynamic> marks =
                  Map<String, dynamic>.from(data['marksheet'] ?? {});

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('FORMATIVE ASSESSMENT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    _marksTable(formative, marks),
                    const SizedBox(height: 20),
                    const Text('SUMMATIVE ASSESSMENT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    _marksTable(summative, marks),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _marksTable(List<String> criteria, Map<String, dynamic> marks) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(1)},
      children: criteria.map((c) {
        return TableRow(children: [
          Padding(padding: const EdgeInsets.all(8), child: Text(c)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              marks[c]?.toString() ?? "-",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ]);
      }).toList(),
    );
  }
}