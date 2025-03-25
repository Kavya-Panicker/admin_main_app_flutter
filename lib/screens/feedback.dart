import 'package:flutter/material.dart';


class FeedbackScreen extends StatefulWidget {
 @override
 _FeedbackScreenState createState() => _FeedbackScreenState();
}


class _FeedbackScreenState extends State<FeedbackScreen>
 with SingleTickerProviderStateMixin {
 late TabController _tabController;


 @override
 void initState() {
  super.initState();
  _tabController = TabController(length: 3, vsync: this);
 }


 @override
 void dispose() {
  _tabController.dispose();
  super.dispose();
 }


 // Dummy data for Requested feedback
 final List<Map<String, dynamic>> requestedFeedbackList = [
  {"title": "Feature Request", "details": "Dark mode"},
  {"title": "Bug Report", "details": "App is slow"},
  {"title": "Improvement", "details": "UI enhancements"},
  {"title": "New Feature", "details": "Offline mode"},
  {"title": "Performance Issue", "details": "Battery drain"},
 ];


 // Dummy data for Responses feedback
 final List<Map<String, dynamic>> responsesFeedbackList = [
  {"title": "Response 1", "details": "User A"},
  {"title": "Response 2", "details": "User B"},
  {"title": "Response 3", "details": "User C"},
  {"title": "Response 4", "details": "User D"},
  {"title": "Response 5", "details": "User E"},
 ];


 // Dummy data for Contributions feedback
 final List<Map<String, dynamic>> contributionsFeedbackList = [
  {"title": "Contribution 1", "details": "Contribution details 1"},
  {"title": "Contribution 2", "details": "Contribution details 2"},
  {"title": "Contribution 3", "details": "Contribution details 3"},
  {"title": "Contribution 4", "details": "Contribution details 4"},
  {"title": "Contribution 5", "details": "Contribution details 5"},
 ];


 @override
 Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(
    title: Text("Feedback"),
    actions: [
     IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () {
       // Handle calendar action
      },
     ),
    ],
    bottom: TabBar(
     controller: _tabController,
     tabs: [
      Tab(text: "Requested"),
      Tab(text: "Responses"),
      Tab(text: "Contributions"),
     ],
    ),
   ),
   body: TabBarView(
    controller: _tabController,
    children: [
     _buildFeedbackTab(requestedFeedbackList),
     _buildFeedbackTab(responsesFeedbackList),
     _buildFeedbackTab(contributionsFeedbackList),
    ],
   ),
  );
 }


 Widget _buildFeedbackTab(List<Map<String, dynamic>> feedbackList) {
  if (feedbackList.isEmpty) {
   return Center(
    child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      Image.network(
       'https://i.imgur.com/Ip74G2F.png',
       height: 100,
       width: 100,
      ),
      SizedBox(height: 20),
      Text(
       "Hey, looks like you do not have any Feedback requests.",
       textAlign: TextAlign.center,
       style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 10),
      Text(
       "Please click the below button to request for Feedback.",
       textAlign: TextAlign.center,
       style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      SizedBox(height: 20),
      ElevatedButton(
       onPressed: () {
        // Handle request feedback
       },
       child: Text("Request Feedback"),
      ),
     ],
    ),
   );
  } else {
   return ListView.builder(
    itemCount: feedbackList.length,
    itemBuilder: (context, index) {
     var feedback = feedbackList[index];
     return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
       title: Text(feedback["title"]),
       subtitle: Text(feedback["details"]),
      ),
     );
    },
   );
  }
 }
}
