import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final String studentEmail;

  const PdfViewPage({
    super.key,
    required this.pdfUrl,
    required this.title,
    required this.studentEmail,
  });

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool _isLoading = true;
  String? _error;
  bool _openedOnce = false; // prevent multiple browser opens

  Future<void> _openPdfInBrowser(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not open PDF';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌐 FLUTTER WEB → open PDF in browser
    if (kIsWeb) {
      if (!_openedOnce) {
        _openedOnce = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _openPdfInBrowser(widget.pdfUrl);
        });
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                widget.studentEmail,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
        ),
        body: const Center(
          child: Text(
            "Opening PDF in browser...",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // 📱 ANDROID / IOS → open inside app
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.studentEmail,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.pdfUrl,
            onDocumentLoaded: (_) {
              setState(() => _isLoading = false);
            },
            onDocumentLoadFailed: (details) {
              setState(() {
                _isLoading = false;
                _error = details.description;
              });
            },
          ),

          if (_isLoading)
            const Center(child: CircularProgressIndicator()),

          if (_error != null)
            Center(
              child: Text(
                "Failed to load PDF\n$_error",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
