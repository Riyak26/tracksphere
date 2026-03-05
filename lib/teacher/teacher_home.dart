import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/progresserbar.dart';

import 'group_detail_page.dart';
import 'marksheet_page.dart';
import 'guide_submission_files_page.dart';
import 'marks_evaluation_page.dart';
import 'package:demo/first_page.dart';

class TeacherHome extends StatefulWidget {
  const TeacherHome({super.key});

  @override
  State<TeacherHome> createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const FirstPage(),
          ),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Guide"),
          centerTitle: true,
        ),
        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search by Project Title...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('groups')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No groups submitted"));
                  }

                  final groups = snapshot.data!.docs;

                  final filteredGroups = groups.where((doc) {
                    final data =
                        doc.data() as Map<String, dynamic>;
                    final title =
                        (data['projectTitle'] ?? "")
                            .toString()
                            .toLowerCase();

                    return title.contains(searchText);
                  }).toList();

                  if (filteredGroups.isEmpty) {
                    return const Center(
                        child: Text("No Matching Groups"));
                  }

                  return ListView.builder(
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      final doc = filteredGroups[index];
                      final data =
                          doc.data() as Map<String, dynamic>;

                      return Stack(
                        children: [

                          Card(
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    data['projectTitle'] ?? '',
                                    style:
                                        const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    "${data['className']} - ${data['section']}",
                                  ),

                                  const SizedBox(height: 10),

                                  ProjectProgressWidget(
                                    groupId: doc.id,
                                  ),

                                  const SizedBox(height: 10),

                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _smallButton(
                                        text: "Students Details",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  GroupDetailPage(
                                                groupId: doc.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      _smallButton(
                                        text: "Submission",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  GuideSubmissionFilesPage(
                                                groupId: doc.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      _smallButton(
                                        text: "Marks Evaluation",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  MarksEvaluationPage(
                                                groupId: doc.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      _smallButton(
                                        text: "Marksheet",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  MarksheetPage(
                                                groupId: doc.id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// ✅ SAFE GREEN TICK FIX
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('groups')
                                .doc(doc.id)
                                .snapshots(),
                            builder: (context, snap) {

                              if (!snap.hasData ||
                                  !snap.data!.exists) {
                                return const SizedBox();
                              }

                              final data =
                                  snap.data!.data()
                                      as Map<String, dynamic>?;

                              bool isApproved =
                                  data?['approved'] == true;

                              if (!isApproved) {
                                return const SizedBox();
                              }

                              return const Positioned(
                                top: 5,
                                right: 5,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
