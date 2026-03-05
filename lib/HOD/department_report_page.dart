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

class _DepartmentReportPageState
    extends State<DepartmentReportPage> {

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
    print("ERROR: $e");

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Department Report"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔹 SUMMARY CARD
                  Card(
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            widget.departmentClass,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Text("Total Groups: $totalGroups"),
                          Text("Completed: $completedGroups"),
                          Text("In Progress: $inProgressGroups"),
                        ],
                      ),
                    ),
                  ),

                  /// ✅ COMPLETED GROUPS OUTER BOX
                  if (completedGroupNames.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Completed Groups",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: completedGroupNames.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  title: Text(completedGroupNames[index]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                  /// ✅ PENDING GROUPS OUTER BOX
                  if (pendingGroupNames.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pending Groups",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 221, 53, 2)),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pendingGroupNames.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.hourglass_empty,
                                      color: Color.fromARGB(255, 221, 53, 2)),
                                  title: Text(pendingGroupNames[index]),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}