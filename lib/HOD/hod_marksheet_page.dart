import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HodMarksheetPage extends StatelessWidget {
  final String groupId;

   HodMarksheetPage({super.key, required this.groupId});

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
      appBar: AppBar(title: const Text("HOD Marksheet")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('marks')      // ✅ CORRECT PATH
            .doc(groupId)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Marks not submitted yet"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final Map<String, dynamic> marks =
              Map<String, dynamic>.from(data['marksheet'] ?? {});

          int total = 0;
          for (var value in marks.values) {
            total += int.tryParse(value.toString()) ?? 0;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [

                const Text(
                  "FORMATIVE ASSESSMENT",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _marksTable(formative, marks),

                const SizedBox(height: 25),

                const Text(
                  "SUMMATIVE ASSESSMENT",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _marksTable(summative, marks),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  color: Colors.indigo.shade50,
                  child: Text(
                    "TOTAL MARKS : $total",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _marksTable(List<String> criteria, Map<String, dynamic> marks) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1),
      },
      children: criteria.map((c) {
        return TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(c),
          ),
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