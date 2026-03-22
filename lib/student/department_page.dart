import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'enroll_group_page.dart';
import '../teacher/marksheet_page.dart';

class SelectDepartmentPage extends StatelessWidget {
  const SelectDepartmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12022F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12022F),
        elevation: 0,
        title: const Text("Department"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            departmentCard(context, "IF6K"),
            const SizedBox(height: 16),
            departmentCard(context, "CO6K"),
            const SizedBox(height: 16),
            departmentCard(context, "EJ6K"),
          ],
        ),
      ),
    );
  }

  Widget departmentCard(BuildContext context, String className) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DepartmentPage(className: className),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1C0B3F),
              Color(0xFF2D115A),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              className,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class DepartmentPage extends StatelessWidget {
  final String className;

  const DepartmentPage({
    super.key,
    required this.className,
  });

  String getDepartmentTitle() {
    if (className.startsWith('IF')) {
      return 'Department of Information Technology';
    } else if (className.startsWith('CO')) {
      return 'Department of Computer Engineering';
    } else if (className.startsWith('EJ')) {
      return 'Department of Electronic & Telecommunication Engineering';
    } else {
      return 'Department';
    }
  }

  Future<String> getStudentGroupId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '';

    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(user.uid)
        .get();

    return doc.exists ? doc.data()!['groupId'] ?? '' : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "TrackSphere",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              String groupId = await getStudentGroupId();

              if (value == 'marksheet') {
                if (groupId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MarksheetPage(groupId: groupId),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Marks not available yet.")),
                  );
                }
              }

              if (value == 'approval') {
                if (groupId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("You are not enrolled in any group.")),
                  );
                  return;
                }

                final doc = await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(groupId)
                    .get();

                bool isApproved = false;

                if (doc.exists) {
                  isApproved = doc.data()?['approved'] ?? false;
                }

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Approval Status"),
                    content: Row(
                      children: [
                        Icon(
                          isApproved ? Icons.check_circle : Icons.cancel,
                          color: isApproved ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isApproved ? "Approved" : "Not Approved Yet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isApproved ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'marksheet',
                child: Text('View Marksheet'),
              ),
              PopupMenuItem(
                value: 'approval',
                child: Text('View Approval'),
              ),
            ],
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Select Section",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Choose your class session",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            sectionCard(context, 'A', true),
            const SizedBox(height: 16),
            sectionCard(context, 'B', false),
            const SizedBox(height: 16),
            sectionCard(context, 'C', false),
          ],
        ),
      ),
    );
  }

  Widget sectionCard(BuildContext context, String section, bool active) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 12),

              Text(
                '$className $section',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F7D5E),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EnrollGroupPage(
                    className: className,
                    section: section,
                  ),
                ),
              );
            },
            child: const Text(
              "Select Section",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}