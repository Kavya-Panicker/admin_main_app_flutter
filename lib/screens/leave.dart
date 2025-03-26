import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

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

class LeaveBalanceTab extends StatefulWidget {
  @override
  _LeaveBalanceTabState createState() => _LeaveBalanceTabState();
}

class _LeaveBalanceTabState extends State<LeaveBalanceTab> {
  List<Map<String, dynamic>> leaveBalances = [
    {
      "leaveType": "Casual Leave",
      "openingBalance": 12,
      "taken": 5,
      "available": 7
    },
    {
      "leaveType": "Sick Leave",
      "openingBalance": 6,
      "taken": 2,
      "available": 4
    },
    {
      "leaveType": "Privileged Leave",
      "openingBalance": 15,
      "taken": 3,
      "available": 12
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: leaveBalances.length,
      itemBuilder: (context, index) {
        final leave = leaveBalances[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leave['leaveType'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Opening Balance: ${leave['openingBalance']}'),
                Text('Taken: ${leave['taken']}'),
                Text('Available: ${leave['available']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HolidaysTab extends StatelessWidget {
  final List<Map<String, String>> holidays = [
    {
      "month": "January",
      "day": "01",
      "name": "New Year Day",
      "weekDay": "Wednesday"
    },
    {
      "month": "January",
      "day": "26",
      "name": "Republic Day",
      "weekDay": "Sunday"
    },
    {"month": "March", "day": "14", "name": "Holi", "weekDay": "Friday"},
    {
      "month": "June",
      "day": "07",
      "name": "Bakra Eid",
      "weekDay": "Saturday"
    },
    {
      "month": "August",
      "day": "15",
      "name": "Independence Day",
      "weekDay": "Friday"
    },
    {
      "month": "October",
      "day": "02",
      "name": "Dussehra/Vijayadashami/Gandhi Jayanti",
      "weekDay": "Thursday"
    },
    {
      "month": "October",
      "day": "20",
      "name": "Choti Deepawali",
      "weekDay": "Monday"
    },
    {
      "month": "October",
      "day": "21",
      "name": "Deepawali",
      "weekDay": "Tuesday"
    },
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
      subtitle:
          Text(holiday['weekDay'] ?? '', style: TextStyle(color: Colors.red)),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(holiday['month'] ?? ''),
      ),
    );
  }
}

class CompOffTab extends StatefulWidget {
  @override
  _CompOffTabState createState() => _CompOffTabState();
}

class _CompOffTabState extends State<CompOffTab> {
  List<Map<String, dynamic>> compOffData = [
    {
      "date": "2025-03-05",
      "reason": "Worked on weekend",
      "status": "Approved",
      "days": 1
    },
    {
      "date": "2025-02-20",
      "reason": "Worked late night",
      "status": "Pending",
      "days": 0.5
    },
    {
      "date": "2025-01-10",
      "reason": "Completed urgent task",
      "status": "Approved",
      "days": 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: compOffData.length,
      itemBuilder: (context, index) {
        final compOff = compOffData[index];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comp-Off Request',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Date: ${compOff['date']}'),
                Text('Reason: ${compOff['reason']}'),
                Text('Status: ${compOff['status']}'),
                Text('Days: ${compOff['days']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
