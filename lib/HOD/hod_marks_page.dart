import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HodMarksPage extends StatefulWidget {
  final String groupId;

  const HodMarksPage({super.key, required this.groupId});

  @override
  State<HodMarksPage> createState() => _HodMarksPageState();
}

class _HodMarksPageState extends State<HodMarksPage> {

  final marksController = TextEditingController();

  void saveMarks() async {
    await FirebaseFirestore.instance
        .collection('marks')
        .doc(widget.groupId)
        .set({
      'groupId': widget.groupId,
      'totalMarks':
          int.parse(marksController.text),
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Marks Saved")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Marks Evaluation")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: marksController,
              decoration: const InputDecoration(
                  labelText: "Total Marks"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveMarks,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}