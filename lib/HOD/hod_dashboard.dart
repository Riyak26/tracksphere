import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hod_files_page.dart';
import 'hod_submission_page.dart';
import 'hod_marksheet_page.dart';
import 'hod_auth_page.dart';
import 'package:demo/HOD/department_report_page.dart';
import 'package:demo/common/progresserbar.dart';

class HodDashboard extends StatefulWidget {
  const HodDashboard({super.key});

  @override
  State<HodDashboard> createState() => _HodDashboardState();
}

class _HodDashboardState extends State<HodDashboard> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOD Dashboard"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const HodAuthPage(),
              ),
              (route) => false,
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DepartmentReportPage(departmentClass: value),
                ),
              );
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem(
                value: "Information Technology",
                child: Text("Information Technology"),
              ),
              PopupMenuItem(
                value: "Computer Engineering",
                child: Text("Computer Engineering"),
              ),
              PopupMenuItem(
                value:
                    "Electronic & Telecommunication Engineering",
                child: Text(
                    "Electronic & Telecommunication Engineering"),
              ),
            ],
          ),
        ],
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
                      child: Text("No Groups Found"));
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
                    final group = filteredGroups[index];
                    final groupId = group.id;
                    final data =
                        group.data() as Map<String, dynamic>;

                    final projectTitle =
                        data['projectTitle'] ??
                            "Untitled Project";
                    final className =
                        data['className'] ?? "";
                    final section =
                        data['section'] ?? "";

                    bool isApproved =
                        data['approved'] ?? false;

                    return Card(
                      margin: const EdgeInsets.all(12),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              projectTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$className - $section",
                              style: const TextStyle(
                                  color: Colors.grey),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Project Progress",
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.w600),
                            ),
                            const SizedBox(height: 8),

                            /// ✅ FIXED: Dynamic Progress Bar
                            ProjectProgressWidget(
                              groupId: groupId,
                            ),

                            const SizedBox(height: 15),

                            SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal,
                              child: Row(
                                children: [
                                  _actionButton(
                                      context,
                                      "Students Details",
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            HodFilesPage(
                                                groupId:
                                                    groupId),
                                      ),
                                    );
                                  }),
                                  const SizedBox(width: 8),
                                  _actionButton(
                                      context,
                                      "Submission",
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            HodSubmissionPage(
                                                groupId:
                                                    groupId),
                                      ),
                                    );
                                  }),
                                  const SizedBox(width: 8),
                                  _actionButton(
                                      context,
                                      "Marksheet",
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            HodMarksheetPage(
                                                groupId:
                                                    groupId),
                                      ),
                                    );
                                  }),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      await FirebaseFirestore
                                          .instance
                                          .collection(
                                              'groups')
                                          .doc(groupId)
                                          .update({
                                        'approved':
                                            !isApproved,
                                      });
                                    },
                                    icon: Icon(
                                      isApproved
                                          ? Icons.check
                                          : Icons
                                              .verified_outlined,
                                      size: 16,
                                      color: isApproved
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    label: Text(
                                      isApproved
                                          ? "Approved"
                                          : "Approve",
                                      style: TextStyle(
                                        color: isApproved
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    style:
                                        ElevatedButton
                                            .styleFrom(
                                      backgroundColor:
                                          isApproved
                                              ? Colors
                                                  .green
                                              : Colors
                                                  .white,
                                      side:
                                          const BorderSide(
                                              color: Colors
                                                  .grey),
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                                  horizontal:
                                                      10,
                                                  vertical:
                                                      8),
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      BuildContext context,
      String title,
      VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(title),
    );
  }
}