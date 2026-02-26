import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'marks_evaluation_page.dart';
import 'marksheet_page.dart';

class GroupDetailPage extends StatelessWidget {
  final String groupId;

  const GroupDetailPage({
    super.key,
    required this.groupId,
  });

  Future<void> _deleteGroup(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Group'),
        content: const Text(
          'Are you sure you want to delete this group?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Group deleted successfully')),
    );

    Navigator.pop(context);
  }

  /// 🔥 THIS CREATES THE marks COLLECTION (FIRST TIME)
  Future<void> _createMarksCollection(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('marks')
          .doc(groupId)
          .set({
        'review1': 0,
        'review2': 0,
        'final': 0,
        'total': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marks collection created')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Group Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteGroup(context),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Group not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List members = data['members'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['projectTitle'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text("Domain: ${data['domain'] ?? '-'}"),
                Text(
                  "Class: ${data['className']} - ${data['section']}",
                ),
                Text("Members: ${members.length}"),

                const SizedBox(height: 20),

                /// 🔹 CREATE MARKS COLLECTION (ONE TIME)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () => _createMarksCollection(context),
                    child: const Text("CREATE MARKS COLLECTION"),
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔹 MARKS BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MarksEvaluationPage(groupId: groupId),
                            ),
                          );
                        },
                        child: const Text("Marks Evaluation"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MarksheetPage(groupId: groupId),
                            ),
                          );
                        },
                        child: const Text("Marksheet"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Text(
                  "Student Details",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                members.isEmpty
                    ? const Text("No students added")
                    : Column(
                        children: members.map((m) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(m['name'] ?? ''),
                              subtitle: Text(
                                "Roll No: ${m['rollNo'] ?? '-'}",
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
