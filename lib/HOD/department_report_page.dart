import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DepartmentReportPage extends StatefulWidget {
  final String departmentClass;

  const DepartmentReportPage({
    Key? key,
    required this.departmentClass,
  }) : super(key: key);

  @override
  State<DepartmentReportPage> createState() =>
      _DepartmentReportPageState();
}

class _DepartmentReportPageState extends State<DepartmentReportPage> {

  int totalGroups = 0;
  int completedGroups = 0;
  int inProgressGroups = 0;
  bool isLoading = true;

  List<String> completedGroupNames = [];
  List<String> pendingGroupNames = [];

  @override
  void initState() {
    super.initState();
    fetchDepartmentData();
  }

  Future<void> fetchDepartmentData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      String selected = widget.departmentClass.trim();

      List<String> possibleMatches = [
        selected,
        selected.replaceAll(" ", ""),
        selected.replaceAll("6K", " 6K"),
      ];

      if (selected.toLowerCase().contains("information")) {
        possibleMatches.addAll(["IF6K", "IF 6K"]);
      }
      if (selected.toLowerCase().contains("computer")) {
        possibleMatches.addAll(["CO6K", "CO 6K", "CE6K"]);
      }
      if (selected.toLowerCase().contains("electronic")) {
        possibleMatches.addAll(["EJ6K", "EJ 6K"]);
      }

      QuerySnapshot groupSnapshot =
          await FirebaseFirestore.instance
              .collection('groups')
              .where('className', whereIn: possibleMatches)
              .get();

      int total = groupSnapshot.docs.length;
      int completed = 0;
      int progress = 0;

      completedGroupNames.clear();
      pendingGroupNames.clear();

      for (var groupDoc in groupSnapshot.docs) {

        String groupId = groupDoc.id;
        String groupName = groupDoc['projectTitle'] ?? "No Title";

        QuerySnapshot submissionSnapshot =
            await FirebaseFirestore.instance
                .collection('submissions')
                .where('groupId', isEqualTo: groupId)
                .get();

        int submissionCount = submissionSnapshot.docs.length;

        if (submissionCount >= 5) {
          completed++;
          completedGroupNames.add(groupName);
        } else if (submissionCount > 0 && submissionCount < 5) {
          progress++;
          pendingGroupNames.add(groupName);
        }
      }

      if (!mounted) return;

      setState(() {
        totalGroups = total;
        completedGroups = completed;
        inProgressGroups = progress;
        isLoading = false;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant DepartmentReportPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.departmentClass != widget.departmentClass) {
      fetchDepartmentData();
    }
  }

  Widget groupCard(String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfff2f2f2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Department Report",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// SUMMARY CARD
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.departmentClass,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Text("Total Groups: $totalGroups",
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 5),
                        Text("Completed: $completedGroups",
                            style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 5),
                        Text("In Progress: $inProgressGroups",
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),

                  /// COMPLETED GROUPS TITLE
                  if (completedGroupNames.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Completed Groups",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  /// COMPLETED GROUPS
                  ...completedGroupNames.map(
                    (name) => groupCard(
                      name,
                      Icons.check,
                      Colors.green,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// PENDING TITLE
                  if (pendingGroupNames.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Pending Groups",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  /// PENDING GROUPS
                  ...pendingGroupNames.map(
                    (name) => groupCard(
                      name,
                      Icons.hourglass_empty,
                      Colors.red,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}