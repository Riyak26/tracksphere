import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/cloudinary_upload_service.dart';

class ReportUploadPage extends StatefulWidget {
  final String groupId;
  final String documentName;

  const ReportUploadPage({
    super.key,
    required this.groupId,
    required this.documentName,
  });

  @override
  State<ReportUploadPage> createState() => _ReportUploadPageState();
}

class _ReportUploadPageState extends State<ReportUploadPage> {
  bool loading = false;
  String? uploadedFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Upload ${widget.documentName}"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// 🔄 LOADING
              if (loading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 25),
              ],

              /// 📂 ICON
              Icon(
                Icons.cloud_upload_rounded,
                size: 90,
                color: Colors.blue.shade400,
              ),

              const SizedBox(height: 20),

              const Text(
                "Upload your PDF file",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Maximum file size: 20MB",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              /// ✅ SUCCESS
              if (!loading && uploadedFileName != null) ...[
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                const SizedBox(height: 10),
                Text(
                  "$uploadedFileName uploaded successfully",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 20),
              ],

              /// 📄 BUTTON
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file),
                  label: const Text(
                    "Select & Upload PDF",
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: loading ? null : _uploadPdf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UPLOAD LOGIC (UNCHANGED) =================

  Future<void> _uploadPdf() async {
    setState(() {
      loading = true;
      uploadedFileName = null;
    });

    try {
      final result = await CloudinaryUploadService.uploadPdf();

      if (result == null ||
          result['url'] == null ||
          result['fileName'] == null) {
        throw "Invalid upload result";
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw "User not logged in";
      }

      final data = {
        "studentId": user.uid,
        "studentEmail": user.email,
        "groupId": widget.groupId,
        "docType": widget.documentName,
        "fileName": result['fileName'],
        "fileUrl": result['url'],
        "uploadedAt": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('submissions')
          .doc(widget.documentName)
          .set(data);

      await FirebaseFirestore.instance
          .collection('submissions')
          .add(data);

      setState(() {
        loading = false;
        uploadedFileName = result['fileName'];
      });

      _showMsg("${widget.documentName} uploaded successfully");
    } catch (e) {
      setState(() => loading = false);
      _showMsg(e.toString());
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}