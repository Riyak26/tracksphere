import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarksheetPage extends StatelessWidget {
  final String groupId;

  MarksheetPage({super.key, required this.groupId});

  final List<Map<String, dynamic>> teamAssessment = [
    {"title": "Project Selection & Problem definition", "max": 30},
    {"title": "Literature survey and data collection/ Gathering", "max": 30},
    {"title": "Design / concept of project/ Working - Execution of Project", "max": 30},
    {"title": "Stage wise progress as per Action plan/milestone", "max": 30},
    {"title": "Quality Report Writing", "max": 30},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Marksheet")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('marks')
            .doc(groupId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text("Marks not submitted yet"),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final Map<String, dynamic> marks =
              Map<String, dynamic>.from(data['marksheet'] ?? {});

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Rubrics for Assessment of the team",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 2),

                _buildTable(teamAssessment, marks),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTable(
      List<Map<String, dynamic>> data, Map<String, dynamic> marks) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(4),
        2: FlexColumnWidth(2),
      },
      children: [

        /// Header Row
        const TableRow(
          decoration: BoxDecoration(color: Colors.grey),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Sr.No",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Criteria",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Marks",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),

        /// Data Rows
        ...List.generate(data.length, (index) {
          var item = data[index];
          String title = item["title"];
          int max = item["max"];

          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("${index + 1}"),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(title),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "${marks[title] ?? 0} / $max",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}