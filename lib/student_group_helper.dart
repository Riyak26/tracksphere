import 'package:cloud_firestore/cloud_firestore.dart';

class StudentGroupHelper {
  static Future<String?> getGroupIdByEmail(String email) async {
    final query = await FirebaseFirestore.instance
        .collection('groups')
        .where('studentEmails', arrayContains: email)
        .get();

    if (query.docs.isEmpty) return null;

    return query.docs.first.id; // THIS IS YOUR groupId
  }
}