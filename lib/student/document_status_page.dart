import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/cloudinary_upload_service.dart';

class DocumentStatusPage extends StatefulWidget {
  final String groupId;
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

      final result = await CloudinaryUploadService.uploadPdf();
      if (result == null) {
        setState(() => loading = false);
        return;
      }

      final user = FirebaseAuth.instance.currentUser!;
      final url = result['url'];
      final fileName = result['fileName'];

      await FirebaseFirestore.instance.collection('submissions').add({
        'groupId': widget.groupId,
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
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "TrackSphere",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 10),

            /// Title
            Text(
              "Submit Your ${widget.documentType}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xff2f6d57),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Please upload your PDF file for your project review.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            /// Upload Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: Colors.green.shade200,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),

              child: Column(
                children: [

                  /// Icon circle
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withOpacity(0.15),
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: Color(0xff2f6d57),
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Upload ${widget.documentType} PDF",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Drag and drop your file here or tap the button below to browse your documents",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Select file button
                  ElevatedButton(
                    onPressed: loading ? null : uploadDocument,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2f6d57),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Select File",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),

                  const SizedBox(height: 15),

                  if (pdfUrl != null)
                    SelectableText(
                      pdfUrl!,
                      style: const TextStyle(color: Colors.green),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// FILE REQUIREMENTS
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "FILE REQUIREMENTS",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xff2f6d57),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "PDF format only (.pdf)",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}