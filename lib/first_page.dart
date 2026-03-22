import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:demo/student/student_login.dart';
import 'teacher/teacher_login.dart';
import 'HOD/hod_auth_page.dart';
import 'about_page.dart';
import 'contact_page.dart';
import 'help_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND IMAGE
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// BLUR
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.white.withOpacity(0.18),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  /// ================= NAVBAR =================
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        /// LOGO
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// moved slightly upward
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: const Icon(
                                Icons.track_changes,
                                color: Colors.teal,
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 6),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  "TrackSphere",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Row(
                                  children: [

                                    const Text(
                                      "VP",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),

                                    const SizedBox(width: 6),

                                    Container(
                                      height: 25,
                                      width: 1.5,
                                      color: Colors.green,
                                    ),

                                    const SizedBox(width: 6),

                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Vidyalankar",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.green)),
                                        Text("Polytechnic",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.green)),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),

                        /// MENU
                        Row(
                          children: [

                            const Text("Home"),
                            const SizedBox(width: 15),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AboutPage()),
                                );
                              },
                              child: const Text("About"),
                            ),

                            const SizedBox(width: 15),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ContactPage()),
                                );
                              },
                              child: const Text("Contact"),
                            ),

                            const SizedBox(width: 15),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const HelpPage()),
                                );
                              },
                              child: const Text("Help"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),

                  /// ================= MAIN CONTENT =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "TrackSphere",
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Project Tracking System",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "A streamlined platform for managing academic projects efficiently.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// BUTTONS
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [

                            SizedBox(
                              width: 150,
                              child: _button(
                                context,
                                text: "Student Login",
                                filled: true,
                              ),
                            ),

                            SizedBox(
                              width: 150,
                              child: _button(
                                context,
                                text: "Guide Login",
                              ),
                            ),

                            SizedBox(
                              width: 150,
                              child: _button(
                                context,
                                text: "HOD Login",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),

                  /// FOOTER
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "PROJECT CREDITS\nDeveloped by: Ishita Raje, Arya Khedekar, Punita Wadkar, Shravani Nirmal",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BUTTON
  static Widget _button(
    BuildContext context, {
    required String text,
    bool filled = false,
  }) {
    return _HoverButton(
      text: text,
      filled: filled,
      onTap: () {
        if (text == "Student Login") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StudentLogin()),
          );
        } else if (text == "Guide Login") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TeacherLogin()),
          );
        } else if (text == "HOD Login") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HodAuthPage()),
          );
        }
      },
    );
  }
}

/// HOVER BUTTON
class _HoverButton extends StatefulWidget {
  final String text;
  final bool filled;
  final VoidCallback onTap;

  const _HoverButton({
    required this.text,
    required this.filled,
    required this.onTap,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {

  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: hovering
            ? (Matrix4.identity()..translate(0, -5))
            : Matrix4.identity(),

        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10),

          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),

            decoration: BoxDecoration(
              color: widget.filled
                  ? const Color.fromARGB(255, 4, 70, 61)
                  : Colors.grey.shade200,

              borderRadius: BorderRadius.circular(10),

              boxShadow: hovering
                  ? [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      )
                    ]
                  : [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
            ),

            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: widget.filled ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}