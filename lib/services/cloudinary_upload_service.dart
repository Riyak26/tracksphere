import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // for kIsWeb

class CloudinaryUploadService {
  static const String cloudName = "dy5efe84i";
  static const String uploadPreset = "student_upload";

  /// Returns map with pdfUrl and fileName
  static Future<Map<String, dynamic>?> uploadPdf() async {
    try {
      // 1️⃣ Pick PDF
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: kIsWeb, // required for web
      );

      if (result == null) return null;

      String fileName = result.files.single.name;

      // 2️⃣ Cloudinary RAW upload URL (IMPORTANT)
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://api.cloudinary.com/v1_1/$cloudName/raw/upload',
        ),
      );

      request.fields['upload_preset'] = uploadPreset;

      // 3️⃣ Web vs Mobile handling
      if (kIsWeb) {
        Uint8List? bytes = result.files.single.bytes;
        if (bytes == null) return null;

        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: fileName,
          ),
        );
      } else {
        File file = File(result.files.single.path!);
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: fileName,
          ),
        );
      }

      // 4️⃣ Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        print("✅ PDF uploaded successfully");
        print("URL: ${data['secure_url']}");

        return {
          "url": data['secure_url'],
          "fileName": fileName,
        };
      } else {
        print("❌ Upload failed: $data");
        return null;
      }
    } catch (e) {
      print("❌ Cloudinary error: $e");
      return null;
    }
  }
}