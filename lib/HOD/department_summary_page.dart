import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DepartmentSummaryPage extends StatefulWidget {
  const DepartmentSummaryPage({Key? key}) : super(key: key);

  @override
  State<DepartmentSummaryPage> createState() =>
      _DepartmentSummaryPageState();
}

class _DepartmentSummaryPageState
    extends State<DepartmentSummaryPage> {

  bool isLoading = true;

  Map<String, Map<String, int>> departmentData = {
    "IF6K": {"total": 0, "completed": 0, "pending": 0},
    "CO6K": {"total": 0, "completed": 0, "pending": 0},
    "EJ6K": {"total": 0, "completed": 0, "pending": 0},
  };

  @override
  void initState() {
    super.initState();
    fetchAllDepartmentsData();
  }

  Future<void> fetchAllDepartmentsData() async {
    try {
      setState(() => isLoading = true);

      // 1️⃣ Get all groups
      QuerySnapshot groupSnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .get();

      // Reset counters
      departmentData.forEach((key, value) {
        value["total"] = 0;
        value["completed"] = 0;
        value["pending"] = 0;
      });

      // 2️⃣ Loop through groups
      for (var groupDoc in groupSnapshot.docs) {

        String groupId = groupDoc.id;
        String className = groupDoc['className'];

        if (!departmentData.containsKey(className)) continue;

        departmentData[className]!["total"] =
            departmentData[className]!["total"]! + 1;

        // 3️⃣ Count submissions for that group
        QuerySnapshot submissionSnapshot =
            await FirebaseFirestore.instance
                .collection('submissions')
                .where('groupId', isEqualTo: groupId)
                .get();

        int submissionCount = submissionSnapshot.docs.length;

        if (submissionCount >= 5) {
          departmentData[className]!["completed"] =
              departmentData[className]!["completed"]! + 1;
        } else if (submissionCount > 0 && submissionCount < 5) {
          departmentData[className]!["pending"] =
              departmentData[className]!["pending"]! + 1;
        }
      }

      setState(() => isLoading = false);

    } catch (e) {
      print("ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  Widget buildDepartmentCard(String classCode, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Text("Total Groups: ${departmentData[classCode]!["total"]}"),
            Text("Completed (5 PDFs): ${departmentData[classCode]!["completed"]}"),
            Text("Pending (<5 PDFs): ${departmentData[classCode]!["pending"]}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Department Summary"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [

                  buildDepartmentCard("IF6K", "Information Technology"),
                  buildDepartmentCard("CO6K", "Computer Engineering"),
                  buildDepartmentCard("EJ6K", "Electronics & Telecommunication"),

                ],
              ),
            ),
    );
  }
}