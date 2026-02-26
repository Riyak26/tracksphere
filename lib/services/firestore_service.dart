import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// 1️⃣ SAVE STUDENT DETAILS
  Future<void> saveStudentDetails({
    required String name,
    required String department,
    required String division,
  }) async {
    final user = _auth.currentUser!;
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': user.email,
      'role': 'student',
      'department': department,
      'division': division,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 2️⃣ CREATE GROUP
  Future<String> createGroup({
    required String projectTitle,
    required String domain,
    required String department,
    required String division,
  }) async {
    final user = _auth.currentUser!;
    final doc = await _db.collection('groups').add({
      'projectTitle': projectTitle,
      'domain': domain,
      'department': department,
      'division': division,
      'studentUid': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  /// 3️⃣ SAVE PDF URL (Cloudinary)
  Future<void> saveSubmission({
    required String groupId,
    required String type,
    required String fileName,
    required String pdfUrl,
  }) async {
    final user = _auth.currentUser!;
    await _db.collection('submissions').add({
      'groupId': groupId,
      'studentUid': user.uid,
      'type': type,
      'fileName': fileName,
      'pdfUrl': pdfUrl,
      'uploadedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 4️⃣ SAVE MARKS
  Future<void> saveMarks({
    required String groupId,
    required int guideMarks,
    required int hodMarks,
    required String remarks,
  }) async {
    await _db.collection('marks').add({
      'groupId': groupId,
      'guideMarks': guideMarks,
      'hodMarks': hodMarks,
      'remarks': remarks,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
