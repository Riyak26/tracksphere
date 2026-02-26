import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarksEvaluationPage extends StatefulWidget {
  final String groupId;

  const MarksEvaluationPage({super.key, required this.groupId});

  @override
  State<MarksEvaluationPage> createState() => _MarksEvaluationPageState();
}

class _MarksEvaluationPageState extends State<MarksEvaluationPage> {
  // Controllers for your UI
  final Map<String, TextEditingController> controllers = {};

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
  void initState() {
    super.initState();
    for (var c in [...formative, ...summative]) {
      controllers[c] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> submitMarks() async {
    Map<String, int> marks = {};

    controllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        marks[key] = int.parse(controller.text);
      }
    });

    // ✅ Save in separate 'marks' collection
    await FirebaseFirestore.instance
        .collection('marks')
        .doc(widget.groupId)
        .set({
      'marksheet': marks,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Marks saved successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Marks Evaluation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _tableTitle("FORMATIVE ASSESSMENT"),
            _marksTable(formative),
            const SizedBox(height: 20),
            _tableTitle("SUMMATIVE ASSESSMENT"),
            _marksTable(summative),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitMarks,
                child: const Text("Submit Marks"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade300,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _marksTable(List<String> criteria) {
    return Table(
      border: TableBorder.all(),
      columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(1)},
      children: criteria.map((c) {
        return TableRow(children: [
          Padding(padding: const EdgeInsets.all(8), child: Text(c)),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controllers[c],
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Marks",
                border: InputBorder.none,
              ),
            ),
          ),
        ]);
      }).toList(),
    );
  }
}