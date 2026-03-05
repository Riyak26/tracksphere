import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'enroll_group_page.dart';
import '../teacher/marksheet_page.dart';

/// ===============================
/// 1️⃣ SELECT DEPARTMENT PAGE
/// (IF6K, CO6K, EJ6K)
/// ===============================

class SelectDepartmentPage extends StatelessWidget {
  const SelectDepartmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Department",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DepartmentPage(className: className),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              className,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// 2️⃣ DEPARTMENT SECTION PAGE
/// (A, B, C)
/// ===============================

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
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Department',
          style: TextStyle(fontWeight: FontWeight.bold),
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
            builder: (_) =>
                MarksheetPage(groupId: groupId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Marks not available yet.")),
        );
      }
    }

    /// ✅ APPROVAL ADDED HERE
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
                isApproved
                    ? Icons.check_circle
                    : Icons.cancel,
                color:
                    isApproved ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isApproved
                    ? "Approved"
                    : "Not Approved Yet",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isApproved
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              getDepartmentTitle(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              className,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            sectionCard(context, 'A'),
            const SizedBox(height: 16),
            sectionCard(context, 'B'),
            const SizedBox(height: 16),
            sectionCard(context, 'C'),
          ],
        ),
      ),
    );
  }

  Widget sectionCard(BuildContext context, String section) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            '$className $section',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
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
              'Enroll',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}