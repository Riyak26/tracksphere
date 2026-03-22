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
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "TrackSphere",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HodAuthPage()),
              (route) => false,
            );
          },
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
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
                value: "Electronic & Telecommunication Engineering",
                child:
                    Text("Electronic & Telecommunication Engineering"),
              ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [

          /// TITLE
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "HOD Dashboard",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// SEARCH BAR
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
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// GROUP LIST
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
                  return const Center(child: Text("No Groups Found"));
                }

                final groups = snapshot.data!.docs;

                final filteredGroups = groups.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title =
                      (data['projectTitle'] ?? "")
                          .toString()
                          .toLowerCase();
                  return title.contains(searchText);
                }).toList();

                return ListView.builder(
                  itemCount: filteredGroups.length,
                  itemBuilder: (context, index) {

                    final group = filteredGroups[index];
                    final groupId = group.id;
                    final data = group.data() as Map<String, dynamic>;

                    final projectTitle =
                        data['projectTitle'] ?? "Untitled";
                    final className = data['className'] ?? "";
                    final section = data['section'] ?? "";
                    bool isApproved = data['approved'] ?? false;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),

                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// PROJECT TITLE
                          Text(
                            projectTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "$className - $section",
                            style: const TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 12),

                          /// PROGRESS BAR
                          ProjectProgressWidget(groupId: groupId),

                          const SizedBox(height: 16),

                          /// BUTTON GRID
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 3.5,

                            children: [

                              _actionButton(
                                  "Students Details", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HodFilesPage(groupId: groupId),
                                  ),
                                );
                              }),

                              _actionButton(
                                  "Submission", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HodSubmissionPage(
                                            groupId: groupId),
                                  ),
                                );
                              }),

                              _actionButton(
                                  "Marksheet", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HodMarksheetPage(
                                            groupId: groupId),
                                  ),
                                );
                              }),

                              ElevatedButton.icon(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('groups')
                                      .doc(groupId)
                                      .update({
                                    'approved': !isApproved,
                                  });
                                },
                                icon: Icon(
                                  isApproved
                                      ? Icons.check
                                      : Icons.verified_outlined,
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isApproved
                                      ? Colors.green
                                      : Colors.white,
                                  side: const BorderSide(
                                      color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _actionButton(String title, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Colors.grey),
        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      child: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}