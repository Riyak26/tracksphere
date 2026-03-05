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
        child: Stack(
          children: [

            /// ================= MAIN CONTENT =================
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 20),

                    /// ================= TOP NAV =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        /// LEFT SIDE
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: const [
                                Text(
                                  "TrackSphere",
                                  style: TextStyle(
                                    fontSize: 20, // reduced
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2B70),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.track_changes,
                                    size: 18,
                                    color: Color(0xFF1F2B70)),
                              ],
                            ),

                           const SizedBox(height: 6),

Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [

    /// BIG VP
    const Text(
      "VP",
      style: TextStyle(
        fontSize: 26,              // adjust size here
        fontWeight: FontWeight.w900,
        color: Colors.green,
        letterSpacing: 1.5,
      ),
    ),

    const SizedBox(width: 8),

    /// VERTICAL LINE
    Container(
      height: 28,
      width: 2,
      color: Colors.green,
    ),

    const SizedBox(width: 8),

    /// TEXT
    const Text(
      "Vidyalankar\nPolytechnic",
      style: TextStyle(
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: Colors.green,
      ),
    ),
  ],
),
                          ],
                        ),

                        /// RIGHT SIDE
                        Row(
                          children: [

                            const Text(
                              "Home",
                              style: TextStyle(fontSize: 14),
                            ),

                            const SizedBox(width: 20),

                            Tooltip(
                              message:
                                  "This application helps Students, Guides, and HODs manage project submissions and tracking.",
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 154, 198, 235),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              child: const Text(
                                "About",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1F2B70),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    /// ================= BIG TITLE (Reduced) =================
                    const Text(
                      "TrackSphere",
                      style: TextStyle(
                        fontSize: 38, // reduced from 54
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2B70),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Project Tracking System",
                      style: TextStyle(
                        fontSize: 20, // reduced
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "A streamlined platform for managing academic\n"
                      "projects, submissions, and evaluations.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// ================= BUTTONS =================
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [

                        _button(
                          context,
                          text: "Student Login",
                          filled: true,
                        ),

                        _button(
                          context,
                          text: "Guide Login",
                        ),

                        _button(
                          context,
                          text: "HOD Login",
                        ),
                      ],
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            /// ================= FIXED BOTTOM TEXT =================
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                color: const Color(0xFFF5F7FB),
                child: const Text(
                  "Developed by: Ishita Raje, Arya Khedekar, Sharavani Nirmal, Punita Wadkar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= BUTTON =================
  static Widget _button(
    BuildContext context, {
    required String text,
    bool filled = false,
  }) {
    return InkWell(
      onTap: () {
        if (text == "Student Login") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentLogin()),
          );
        } else if (text == "Guide Login") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TeacherLogin()),
          );
        } else if (text == "HOD Login") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HodAuthPage()),
          );
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: filled
              ? const Color(0xFF1F2B70)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF1F2B70),
            width: 1.3,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: filled
                ? Colors.white
                : const Color(0xFF1F2B70),
          ),
        ),
      ),
    );
  }
}