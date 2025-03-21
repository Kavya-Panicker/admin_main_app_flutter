import 'package:flutter/material.dart';
import 'task_box.dart';
import 'leave.dart';
import 'performance.dart';
import 'feedback.dart';
import 'hr_documents.dart';
import 'recruitment.dart';
import 'helpdesk.dart';
import 'employee.dart';
import 'flows.dart';
import 'events.dart';
import 'profile.dart'; // Ensure this import is correct
import 'notifications.dart';
import 'attendance.dart';
import 'payroll.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int notificationCount = 3; // Example: 3 new notifications
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profileImagePath') ?? '';
    });
  }

  // List of Dashboard Items
  final List<Map<String, dynamic>> dashboardItems = [
    {
      'icon': Icons.task,
      'title': "Task Box",
      'color': Colors.blue,
      'screen': TaskBoxScreen(),
    },
    {
      'icon': Icons.access_time,
      'title': "Attendance",
      'color': Colors.green,
      'screen': AttendanceScreen(),
    },
    {
      'icon': Icons.beach_access,
      'title': "Leave",
      'color': Colors.orange,
      'screen': LeaveScreen(),
    },
    {
      'icon': Icons.trending_up,
      'title': "Performance",
      'color': Colors.purple,
      'screen': PerformanceScreen(),
    },
    {
      'icon': Icons.feedback,
      'title': "Feedback",
      'color': Colors.teal,
      'screen': FeedbackScreen(),
    },
    {
      'icon': Icons.description,
      'title': "HR Documents",
      'color': Colors.red,
      'screen': HRDocumentsScreen(),
    },
    {
      'icon': Icons.group,
      'title': "Recruitment",
      'color': Colors.indigo,
      'screen': RecruitmentScreen(),
    },
    {
      'icon': Icons.help,
      'title': "Helpdesk",
      'color': Colors.brown,
      'screen': HelpdeskScreen(),
    },
    {
      'icon': Icons.people,
      'title': "Employee",
      'color': Colors.deepPurple,
      'screen': EmployeeScreen(),
    },
    {
      'icon': Icons.sync_alt,
      'title': "Flows",
      'color': Colors.pink,
      'screen': FlowsScreen(),
    },
    {
      'icon': Icons.celebration,
      'title': "Events",
      'color': Colors.deepOrange,
      'screen': EventsScreen(),
    },
    {
      'icon': Icons.attach_money,
      'title': "Payroll",
      'color': Colors.amber,
      'screen': PayrollScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              itemCount: dashboardItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 600 ? 4 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final item = dashboardItems[index];
                return _buildDashboardItem(
                  item['icon'],
                  item['title'],
                  item['color'],
                  item['screen'],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // App Bar with Notifications and Profile Icon
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "Dashboard",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.blue, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
                  ),
                );
                setState(() => notificationCount = 0);
              },
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: _buildNotificationBadge(notificationCount),
              ),
          ],
        ),
        IconButton(
          icon: CircleAvatar(
            backgroundImage:
                _profileImagePath != null && _profileImagePath!.isNotEmpty
                    ? FileImage(File(_profileImagePath!))
                        as ImageProvider<Object>?
                    : AssetImage('assets/default_profile.png')
                        as ImageProvider<Object>?,
            backgroundColor: Colors.grey,
          ),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );

            if (result != null && result is String) {
              setState(() {
                _profileImagePath = result;
              });

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('profileImagePath', _profileImagePath!);
            }
          },
        ),
      ],
    );
  }

  // Notification Badge
  Widget _buildNotificationBadge(int count) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      child: Text(
        '$count',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Dashboard Items
  Widget _buildDashboardItem(
    IconData icon,
    String title,
    Color color,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
