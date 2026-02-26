import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HodSubmissionPage extends StatelessWidget {
  final String groupId;

  const HodSubmissionPage({
    super.key,
    required this.groupId,
  });

  Future<void> openPdf(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception("Could not launch URL");
      }
    } catch (e) {
      debugPrint("Error opening PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOD Submissions"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
    .collection('submissions')
    .where('groupId', isEqualTo: groupId)
    .snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          // No Data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No submissions yet"),
            );
          }

          final submissions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final data =
                  submissions[index].data() as Map<String, dynamic>;

              final studentName =
                  data['studentName'] ?? "Unknown Student";

              final fileName =
                  data['fileName'] ?? "No File Name";

              final fileUrl =
                  data['fileUrl'] ?? "";

              final uploadedAt =
                  (data['uploadedAt'] as Timestamp?)?.toDate();

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                elevation: 3,
                child: ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red,
                  ),
                  title: Text(
                    fileName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text("Submitted by: $studentName"),
                      if (uploadedAt != null)
                        Text(
                          "Date: ${uploadedAt.day}/${uploadedAt.month}/${uploadedAt.year}",
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: fileUrl.isNotEmpty
                        ? () => openPdf(fileUrl)
                        : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}