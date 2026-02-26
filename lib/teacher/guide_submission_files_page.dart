import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/common/PdfViewPage.dart';

class GuideSubmissionFilesPage extends StatelessWidget {
  final String groupId;

  const GuideSubmissionFilesPage({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 DEBUG PRINT
    print("Guide page received groupId: $groupId");

    return Scaffold(
      appBar: AppBar(
        title: Text("Submissions • $groupId"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
    .collection('submissions')
    .where('groupId', isEqualTo: groupId)
    .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Firestore error: ${snapshot.error}");
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print("No submissions found for groupId: $groupId");
            return const Center(
              child: Text("No submissions for this group"),
            );
          }

          print("Found ${snapshot.data!.docs.length} submissions");

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final String fileUrl = data['fileUrl'];
              final String docType = data['docType'];
              final String studentEmail = data['studentEmail'];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red,
                    size: 32,
                  ),
                  title: Text(
                    docType,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(studentEmail),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfViewPage(
                          pdfUrl: fileUrl,
                          title: docType,
                          studentEmail: studentEmail,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}