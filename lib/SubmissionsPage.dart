import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmissionsPage extends StatelessWidget {
  final String groupId;

  const SubmissionsPage({super.key, required this.groupId});

  Future<void> _openPdf(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open PDF';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Submissions')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('submissions')
            .orderBy('submittedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No PDFs submitted yet'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(data['documentType'] ?? 'Document'),
                  subtitle: Text(
                    'Student: ${data['studentName'] ?? 'Unknown'}',
                  ),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openPdf(data['pdfUrl']),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
