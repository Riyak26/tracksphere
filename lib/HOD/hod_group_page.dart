import 'package:flutter/material.dart';
import 'hod_students_page.dart';
import 'hod_submission_page.dart';
import 'hod_marks_page.dart';
import 'hod_marksheet_page.dart';

class HodGroupPage extends StatelessWidget {
  final String groupId;
  final int index;

  const HodGroupPage(
      {super.key,
      required this.groupId,
      required this.index});

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return HodStudentsPage(groupId: groupId);
      case 1:
        return HodSubmissionPage(groupId: groupId);
      case 2:
        return HodMarksPage(groupId: groupId);
      case 3:
        return HodMarksheetPage(groupId: groupId);
      default:
        return const Scaffold(
            body: Center(child: Text("Invalid Page")));
    }
  }
}