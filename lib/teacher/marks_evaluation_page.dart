import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarksEvaluationPage extends StatefulWidget {
  final String groupId;

  const MarksEvaluationPage({super.key, required this.groupId});

  @override
  State<MarksEvaluationPage> createState() => _MarksEvaluationPageState();
}

class _MarksEvaluationPageState extends State<MarksEvaluationPage> {

  final Map<String, TextEditingController> controllers = {};

  final List<Map<String, dynamic>> teamAssessment = [
    {"title": "Project Selection & Problem definition", "max": 30},
    {"title": "Literature survey and data collection/ Gathering", "max": 30},
    {"title": "Design / concept of project/ Working - Execution of Project", "max": 30},
    {"title": "Stage wise progress as per Action plan/milestone", "max": 30},
    {"title": "Quality Report Writing", "max": 30},
  ];

  @override
  void initState() {
    super.initState();

    // Safe controller initialization
    for (var item in teamAssessment) {
      controllers[item["title"]] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> submitMarks() async {
    Map<String, int> marks = {};

    controllers.forEach((key, controller) {
      if (controller.text.isNotEmpty) {
        marks[key] = int.tryParse(controller.text) ?? 0;
      }
    });

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
      appBar: AppBar(
        title: const Text("Marks Evaluation"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// -------- TEAM ASSESSMENT ONLY --------
            const Text(
              "Rubrics for Assessment of the team",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 2),

            _buildTable(teamAssessment),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submitMarks,
                child: const Text(
                  "Submit Marks",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> data) {
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
              child: Text(
                "Sr.No",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Criteria",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Marks",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        /// Data Rows
        ...List.generate(data.length, (index) {
          var item = data[index];
          String title = item["title"];
          int max = item["max"];

          controllers.putIfAbsent(title, () => TextEditingController());

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
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controllers[title],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "/$max",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}