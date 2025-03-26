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
          icon: Icon(Icons.arrow_back,
              color: Colors.black), // Set back arrow color to black
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
            () => _showGoalPlanDetails(context),
          ),
          _buildPerformanceOption(
            context,
            "Review",
            Icons.star_border,
            Colors.orange, // Icon color for Review
            () => _showReviewDetails(context),
          ),
          _buildPerformanceOption(
            context,
            "MSF",
            Icons.people_outline,
            Colors.blueAccent, // Icon color for MSF
            () => _showMSFDetails(context),
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
    VoidCallback onTap,
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
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showGoalPlanDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Goal Plan Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Goal: Increase sales by 15% in Q2 2025"),
              Text("Status: In Progress"),
              Text("Due Date: 2025-06-30"),
              Text("Progress: 60%"),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showReviewDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Review Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Reviewer: John Doe"),
              Text("Date: 2025-03-22"),
              Text("Overall Rating: Excellent"),
              Text("Comments: Great performance, keep it up!"),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMSFDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("MSF (Multi-Source Feedback) Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Feedback from: Peers, Manager, Subordinates"),
              Text("Summary: Positive feedback on teamwork and communication skills."),
              Text("Areas for improvement: Delegation"),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
