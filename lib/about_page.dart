import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'This application is designed to simplify and digitalize the management of final year student projects. '
            'It helps Students, Guides, and HODs manage project submissions, evaluations, and tracking in a structured and transparent way.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
