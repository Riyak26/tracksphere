import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class studentmarksheetpage extends StatelessWidget {
  final String studentEmail; // use email to fetch marks

  studentmarksheetpage({super.key, required this.studentEmail});

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
    final marksRef = FirebaseFirestore.instance
        .collection('nam5') // your collection
        .where('email', isEqualTo: studentEmail)
        .orderBy('createdAt', descending: true)
        .limit(1);

    return Scaffold(
      appBar: AppBar(title: const Text("Marksheet")),
      body: StreamBuilder<QuerySnapshot>(
        stream: marksRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Marks not submitted yet for your email"),
            );
          }

          final data = snapshot.data!.docs[0].data() as Map<String, dynamic>;
          final Map<String, dynamic> marks =
              Map<String, dynamic>.from(data['marksheet'] ?? {});

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text("FORMATIVE ASSESSMENT", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _marksTable(formative, marks),
                const SizedBox(height: 20),
                const Text("SUMMATIVE ASSESSMENT", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _marksTable(summative, marks),
              ],
            ),
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
