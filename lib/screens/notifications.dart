import 'package:flutter/material.dart';
import 'dart:async';

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
  });
}

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scheduleUpcomingEventNotification();
  }

  void _loadNotifications() {
    setState(() {
      notifications = [
        NotificationItem(
          title: "Task Completed",
          description: "John Doe has completed the software update task.",
          time: "Just now",
          icon: Icons.check_circle,
        ),
        NotificationItem(
          title: "Leave Request",
          description: "Jane Smith has requested leave from Sept 5 - Sept 10.",
          time: "2 hours ago",
          icon: Icons.event_busy,
        ),
        NotificationItem(
          title: "Payroll Processed",
          description: "Salary for the month of August has been processed.",
          time: "Yesterday",
          icon: Icons.payment,
        ),
      ];
    });
  }

  void _scheduleUpcomingEventNotification() {
    Timer(Duration(seconds: 5), () {
      setState(() {
        notifications.insert(
          0,
          NotificationItem(
            title: "Upcoming Event Reminder",
            description: "Annual Company Meetup is tomorrow!",
            time: "Now",
            icon: Icons.event,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: notifications.isEmpty
          ? Center(child: Text("No new notifications"))
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var notification = notifications[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(notification.icon, color: Colors.blue),
                    title: Text(notification.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(notification.description),
                    trailing: Text(notification.time, style: TextStyle(color: Colors.grey)),
                  ),
                );
              },
            ),
    );
  }
}
