import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'document_status_page.dart';
import 'student_group_list_page.dart';
import '../first_page.dart';

class EnrollGroupPage extends StatefulWidget {
  final String className;
  final String section;

  const EnrollGroupPage({
    super.key,
    required this.className,
    required this.section,
  });

  @override
  State<EnrollGroupPage> createState() => _EnrollGroupPageState();
}

class _EnrollGroupPageState extends State<EnrollGroupPage> {
  int selectedMembers = 2;

  final TextEditingController projectTitleController =
      TextEditingController();
  final TextEditingController domainController =
      TextEditingController();

  List<TextEditingController> nameControllers = [];
  List<TextEditingController> rollControllers = [];

  String? groupId;

  @override
  void initState() {
    super.initState();
    _initMemberControllers(2);
  }

  void _initMemberControllers(int count) {
    for (final c in nameControllers) {
      c.dispose();
    }
    for (final c in rollControllers) {
      c.dispose();
    }

    nameControllers =
        List.generate(count, (_) => TextEditingController());
    rollControllers =
        List.generate(count, (_) => TextEditingController());
  }

  @override
  void dispose() {
    projectTitleController.dispose();
    domainController.dispose();
    for (final c in nameControllers) {
      c.dispose();
    }
    for (final c in rollControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> submitGroup() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('❌ User not logged in');
      return;
    }

    if (projectTitleController.text.isEmpty ||
        domainController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields')),
      );
      return;
    }

    final members = List.generate(selectedMembers, (i) {
      return {
        'name': nameControllers[i].text.trim(),
        'rollNo': rollControllers[i].text.trim(),
      };
    });

    try {
      final docRef =
          FirebaseFirestore.instance.collection('groups').doc();

      await docRef.set({
        'groupId': docRef.id,
        'studentUid': user.uid,
        'studentEmail': user.email,
        'className': widget.className,
        'section': widget.section,
        'projectTitle': projectTitleController.text.trim(),
        'domain': domainController.text.trim(),
        'members': members,
        'membersCount': selectedMembers,
        'documents': {},
        'marks': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .set({
        'email': user.email,
        'groupId': docRef.id,
      }, SetOptions(merge: true));

      setState(() {
        groupId = docRef.id;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group submitted successfully')),
      );
    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save group')),
      );
    }
  }

  InputDecoration fieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget memberCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              if (index == 0)
                const Icon(Icons.circle,
                    color: Colors.green, size: 10),

              const SizedBox(width: 8),

              Text(
                index == 0
                    ? "Member 1"
                    : "Member ${index + 1}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextField(
            controller: nameControllers[index],
            decoration:
                fieldStyle(index == 0 ? "Member Name" : "Member Name"),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: rollControllers[index],
            decoration: fieldStyle("Roll No"),
          ),
        ],
      ),
    );
  }

  Widget memberSelector() {
    List<int> counts = [2, 3, 4];

    return Row(
      children: counts.map((count) {
        bool selected = selectedMembers == count;

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedMembers = count;
                _initMemberControllers(count);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xff4c7a67)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count Members",
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Enroll Your Group',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),

       actions: [
  PopupMenuButton<String>(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    onSelected: (value) async {

      if (value == 'logout') {
        await FirebaseAuth.instance.signOut();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const FirstPage(),
          ),
          (route) => false,
        );
      }

      if (groupId == null && value != 'logout') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Submit group first')),
        );
        return;
      }

      if (value == 'Marksheet') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const StudentGroupListPage(),
          ),
        );
      } else if (value != 'logout') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DocumentStatusPage(
              groupId: groupId!,
              documentType: value,
            ),
          ),
        );
      }
    },

    itemBuilder: (context) => [

      const PopupMenuItem(
        value: 'Abstract',
        child: Row(
          children: [
            Icon(Icons.description, color: Colors.green),
            SizedBox(width: 10),
            Text("Abstract"),
          ],
        ),
      ),

      const PopupMenuItem(
        value: 'Synopsis',
        child: Row(
          children: [
            Icon(Icons.grid_view, color: Colors.green),
            SizedBox(width: 10),
            Text("Synopsis"),
          ],
        ),
      ),

      const PopupMenuItem(
        value: 'Survey',
        child: Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green),
            SizedBox(width: 10),
            Text("Survey"),
          ],
        ),
      ),

      const PopupMenuItem(
        value: 'PPT',
        child: Row(
          children: [
            Icon(Icons.play_arrow, color: Colors.green),
            SizedBox(width: 10),
            Text("PPT"),
          ],
        ),
      ),

      const PopupMenuItem(
        value: 'Blackbook',
        child: Row(
          children: [
            Icon(Icons.menu_book, color: Colors.green),
            SizedBox(width: 10),
            Text("Blackbook"),
          ],
        ),
      ),

      const PopupMenuDivider(),

      const PopupMenuItem(
        value: 'logout',
        child: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    ],
  ),
],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Column(
                children: [
                  const Text(
                    "DEPARTMENT",
                    style: TextStyle(
                        color: Colors.grey,
                        letterSpacing: 2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.className} - ${widget.section}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Select No. of Members",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            memberSelector(),

            const SizedBox(height: 22),

            const Text("Project Title",
                style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            TextField(
              controller: projectTitleController,
              decoration: fieldStyle("Enter project name"),
            ),

            const SizedBox(height: 16),

            const Text("Project Domain",
                style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 8),

            TextField(
              controller: domainController,
              decoration:
                  fieldStyle("e.g. AI, Web Development"),
            ),

            const SizedBox(height: 24),

            Column(
              children: List.generate(
                  selectedMembers, (index) => memberCard(index)),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: submitGroup,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xff4c7a67),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Submit Group Enrollment",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "By enrolling, you agree to the project guidelines.",
                style: TextStyle(
                    color: Colors.grey, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}