import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Widget teamCard(String initials, String name, String phone) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [

          /// Circle Avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.green.shade100,
            child: Text(
              initials,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),

          const SizedBox(width: 15),

          /// Name + Phone
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                phone,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("TrackSphere"),
        foregroundColor: Colors.green,
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      backgroundColor: Colors.grey.shade100,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Our Team",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          teamCard("IR", "Ishita Raje", "+91 9321828211"),
          teamCard("AK", "Arya Khedekar", "+91 7045631030"),
          teamCard("PW", "Punita Wadkar", "+91 9321897533"),
          teamCard("SN", "Shravani Nirmal", "+91 8591030620"),
        ],
      ),
    );
  }
}