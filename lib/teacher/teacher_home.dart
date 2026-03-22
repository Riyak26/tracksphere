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
        backgroundColor: const Color(0xFFF5F5F5),

        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF5F5F5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const FirstPage()),
                (route) => false,
              );
            },
          ),
          title: const Text(
            "TrackSphere",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Guide Dashboard",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Manage student projects and evaluations",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search projects...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "ACTIVE PROJECTS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 10),

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

                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.05),
                                  blurRadius: 8,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  data['projectTitle'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  "${data['className']} - ${data['section']}",
                                  style: const TextStyle(
                                      color: Colors.grey),
                                ),

                                const SizedBox(height: 12),

                                const Text(
                                  "Project Progress",
                                  style: TextStyle(
                                      fontWeight:
                                          FontWeight.w600),
                                ),

                                const SizedBox(height: 6),

                                ProjectProgressWidget(
                                  groupId: doc.id,
                                ),

                                const SizedBox(height: 12),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _smallButton(
                                      text:
                                          "Students Details",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                GroupDetailPage(
                                              groupId:
                                                  doc.id,
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
                                              groupId:
                                                  doc.id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    _smallButton(
                                      text:
                                          "Marks Evaluation",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                MarksEvaluationPage(
                                              groupId:
                                                  doc.id,
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
                                              groupId:
                                                  doc.id,
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
                                top: 10,
                                right: 20,
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
          backgroundColor: const Color(0xFF2F6F4E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}