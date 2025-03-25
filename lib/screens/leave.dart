import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LeaveScreen extends StatefulWidget {
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with TickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leave"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Leave balance"),
            Tab(text: "Holidays"),
            Tab(text: "Comp off"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () {},
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LeaveBalanceTab(),
          HolidaysTab(),
          CompOffTab(),
        ],
      ),
    );
  }
}

class LeaveBalanceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Leave Balance Content"),
    );
  }
}

class HolidaysTab extends StatelessWidget {
  final List<Map<String, String>> holidays = [
    {"month": "January", "day": "01", "name": "New Year Day", "weekDay": "Wednesday"},
    {"month": "January", "day": "26", "name": "Republic Day", "weekDay": "Sunday"},
    {"month": "March", "day": "14", "name": "Holi", "weekDay": "Friday"},
    {"month": "June", "day": "07", "name": "Bakra Eid", "weekDay": "Saturday"},
    {"month": "August", "day": "15", "name": "Independence Day", "weekDay": "Friday"},
    {"month": "October", "day": "02", "name": "Dussehra/Vijayadashami/Gandhi Jayanti", "weekDay": "Thursday"},
    {"month": "October", "day": "20", "name": "Choti Deepawali", "weekDay": "Monday"},
    {"month": "October", "day": "21", "name": "Deepawali", "weekDay": "Tuesday"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "TOTAL 11 HOLIDAYS THIS YEAR",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ...holidays.map((holiday) => HolidayItem(holiday: holiday)).toList(),
      ],
    );
  }
}

class HolidayItem extends StatelessWidget {
  final Map<String, String> holiday;

  HolidayItem({required this.holiday});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${holiday['day'] ?? ''} ${holiday['name'] ?? ''}"),
      subtitle: Text(holiday['weekDay'] ?? '', style: TextStyle(color: Colors.red)),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(holiday['month'] ?? ''),
      ),
    );
  }
}

class CompOffTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Comp Off Content"),
    );
  }
}
