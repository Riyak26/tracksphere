import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/cloudinary_upload_service.dart';

class DocumentStatusPage extends StatefulWidget {
  final String groupId;       // 🔥 MUST BE FIRESTORE DOC ID
  final String documentType;

  const DocumentStatusPage({
    super.key,
    required this.groupId,
    required this.documentType,
  });

  @override
  State<DocumentStatusPage> createState() => _DocumentStatusPageState();
}

class _DocumentStatusPageState extends State<DocumentStatusPage> {
  bool loading = false;
  String? pdfUrl;

  Future<void> uploadDocument() async {
    try {
      setState(() => loading = true);

      /// 1️⃣ Upload PDF to Cloudinary
      final result = await CloudinaryUploadService.uploadPdf();
      if (result == null) {
        setState(() => loading = false);
        return;
      }

      final user = FirebaseAuth.instance.currentUser!;
      final url = result['url'];
      final fileName = result['fileName'];

      /// 🔥 DEBUG (you can remove later)
      print("Uploading for groupId: ${widget.groupId}");

      /// 2️⃣ SAVE IN submissions collection
      await FirebaseFirestore.instance.collection('submissions').add({
        'groupId': widget.groupId,   // ✅ THIS MUST MATCH doc.id
        'docType': widget.documentType,
        'fileUrl': url,
        'fileName': fileName,
        'studentUid': user.uid,
        'studentEmail': user.email,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        loading = false;
        pdfUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.documentType} uploaded')),
      );
    } catch (e) {
      setState(() => loading = false);
      print("Upload error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.documentType)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: loading ? null : uploadDocument,
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload PDF"),
            ),
            const SizedBox(height: 20),

            if (loading)
              const CircularProgressIndicator(),

            if (pdfUrl != null)
              SelectableText(
                pdfUrl!,
                style: const TextStyle(color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}