import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class GuideFilesPage extends StatelessWidget {
  final String guideId;
  final String groupId;

  const GuideFilesPage({
    super.key,
    required this.guideId,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Group $groupId Files")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('submissions')
            .where('guideId', isEqualTo: guideId)
            .where('groupId', isEqualTo: groupId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No files uploaded"));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return Card(
                child: ListTile(
                  title: Text(doc['docType']),
                  subtitle: Text(doc['fileName']),
                  trailing: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  onTap: () async {
                    final url = Uri.parse(doc['fileUrl']);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}