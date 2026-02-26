import 'package:flutter/material.dart';
import 'package:demo/student/student_login.dart';
import 'teacher/teacher_login.dart';
import 'HOD/hod_auth_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Column(
          children: [

            /// =======================
            /// TOP NAV BAR
            /// =======================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// LOGO + TITLE
                  Row(
                    children: const [
                      Text(
                        "TrackSphere",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2B70),
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.track_changes, color: Color(0xFF1F2B70))
                    ],
                  ),

                  /// MENU
                  Row(
                    children: const [
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 24),
                      Text(
                        "About",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1F2B70),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const Spacer(),

            /// =======================
            /// CENTER CONTENT
            /// =======================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "TrackSphere",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2B70),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Project Tracking System",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "A streamlined platform for managing\n"
                    "academic projects, submissions, and evaluations.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// =======================
                  /// BUTTONS
                  /// =======================
                  Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [

                      /// STUDENT LOGIN (Filled)
                      _button(
                        text: "Student Login",
                        filled: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => StudentLogin()),
                          );
                        },
                      ),

                      /// GUIDE LOGIN
                      _button(
                        text: "Guide Login",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TeacherLogin()),
                          );
                        },
                      ),

                      /// HOD LOGIN
                      _button(
                        text: "HOD Login",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => HodAuthPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  /// =======================
  /// BUTTON DESIGN
  /// =======================
  static Widget _button({
    required String text,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF1F2B70) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF1F2B70),
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: filled ? Colors.white : const Color(0xFF1F2B70),
          ),
        ),
      ),
    );
  }
}