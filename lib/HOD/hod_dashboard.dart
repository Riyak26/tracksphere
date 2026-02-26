import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'hod_files_page.dart';
import 'hod_submission_page.dart';
import 'hod_marksheet_page.dart';
import 'hod_auth_page.dart';

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
      ),

      body: Column(
        children: [

          // ✅ SEARCH BAR ADDED HERE
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

          // ✅ GROUP LIST
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

                // ✅ FILTER GROUPS BASED ON SEARCH
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
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(
                                      10),
                              child:
                                  LinearProgressIndicator(
                                value: 0.16,
                                minHeight: 8,
                                backgroundColor:
                                    Colors.grey
                                        .shade300,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "1 of 6 uploaded (16%)",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
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
                              ],
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
          borderRadius:
              BorderRadius.circular(20),
        ),
      ),
      child: Text(title),
    );
  }
}