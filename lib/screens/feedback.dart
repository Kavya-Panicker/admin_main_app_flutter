import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<Map<String, dynamic>> feedbackList = [
    {"title": "App is slow", "category": "Bug Report", "status": "Pending"},
    {"title": "Add dark mode", "category": "Feature Request", "status": "In Progress"},
    {"title": "Improve UI", "category": "Suggestion", "status": "Resolved"},
  ];

  void updateStatus(int index, String newStatus) {
    setState(() {
      feedbackList[index]["status"] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Feedback")),
      body: ListView.builder(
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          var feedback = feedbackList[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(feedback["title"]),
              subtitle: Text("Category: ${feedback["category"]}"),
              trailing: DropdownButton<String>(
                value: feedback["status"],
                items: ["Pending", "In Progress", "Resolved"]
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) updateStatus(index, newStatus);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
