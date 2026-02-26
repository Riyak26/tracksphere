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

      // ✅ FIXED PART (ONLY THIS WAS CHANGED)
      await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .set({
        'email': user.email,
        'groupId': docRef.id,
      }, SetOptions(merge: true));

      print("✅ Student groupId saved: ${docRef.id}");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enroll Your Group'),
        actions: [
          PopupMenuButton<String>(
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
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Abstract', child: Text('Abstract')),
              PopupMenuItem(value: 'Synopsis', child: Text('Synopsis')),
              PopupMenuItem(value: 'Survey', child: Text('Survey')),
              PopupMenuItem(value: 'PPT', child: Text('PPT')),
              PopupMenuItem(value: 'Blackbook', child: Text('Blackbook')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.className} - ${widget.section}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select No. of Members',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                children: List.generate(5, (i) {
                  final count = i + 1;
                  return ChoiceChip(
                    label: Text('$count'),
                    selected: selectedMembers == count,
                    onSelected: (_) {
                      setState(() {
                        selectedMembers = count;
                        _initMemberControllers(count);
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: projectTitleController,
                decoration: const InputDecoration(
                  labelText: 'Project Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: domainController,
                decoration: const InputDecoration(
                  labelText: 'Domain',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Team Members',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                children: List.generate(selectedMembers, (index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameControllers[index],
                            decoration: InputDecoration(
                              labelText:
                                  'Member ${index + 1} Name',
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: rollControllers[index],
                            decoration: InputDecoration(
                              labelText:
                                  'Member ${index + 1} Roll No',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitGroup,
                  child: const Text('Submit Group'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}