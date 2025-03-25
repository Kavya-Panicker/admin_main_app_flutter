 import 'package:flutter/material.dart';
 

 class PerformanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
     title: Text(
      "Performance",
      style: TextStyle(
       fontWeight: FontWeight.bold,
       color: Colors.black), // Set title color to black
     ),
     centerTitle: false,
     backgroundColor: Colors.white, // Set background color to white
     elevation: 0,
     leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black), // Set back arrow color to black
      onPressed: () {
       Navigator.pop(context);
      },
     ),
    ),
    backgroundColor: Colors.white, // Set background color to white
    body: ListView(
     padding: const EdgeInsets.all(16.0),
     children: [
      _buildPerformanceOption(
       context,
       "Goal Plan",
       Icons.flag_outlined,
       Colors.blue, // Icon color for Goal Plan
      ),
      _buildPerformanceOption(
       context,
       "Review",
       Icons.star_border,
       Colors.orange, // Icon color for Review
      ),
      _buildPerformanceOption(
       context,
       "MSF",
       Icons.people_outline,
       Colors.blueAccent, // Icon color for MSF
      ),
     ],
    ),
   );
  }
 

  Widget _buildPerformanceOption(
   BuildContext context,
   String title,
   IconData icon,
   Color iconColor,
  ) {
   return Card(
    elevation: 0, // remove shadow
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Colors.grey[50], // Background color of the card
    child: ListTile(
     leading: CircleAvatar(
      backgroundColor: Colors.grey[50], // Background color of the circle
      child: Icon(icon, color: iconColor),
     ),
     title: Text(title, style: TextStyle(fontWeight: FontWeight.w400)),
     trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), // Color of the arrow
     onTap: () {
      // Handle navigation or action
     },
    ),
   );
  }
 }
