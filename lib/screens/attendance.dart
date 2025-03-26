import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../utils/gps_helper.dart';
import 'face_recognition_screen.dart';
import 'attendance_view_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with TickerProviderStateMixin {
  bool isCheckedIn = false;
  List<CameraDescription>? cameras;
  String? checkInTime;
  String? checkOutTime;
  String? status;
  List<Map<String, String>> attendanceHistory = [
    {
      "Date": "2025-03-17",
      "Check In": "09:00 AM",
      "Check Out": "05:00 PM",
      "Status": "On-Time"
    },
    {
      "Date": "2025-03-18",
      "Check In": "08:55 AM",
      "Check Out": "05:05 PM",
      "Status": "On-Time"
    },
    {
      "Date": "2025-03-19",
      "Check In": "09:10 AM",
      "Check Out": "05:15 PM",
      "Status": "Late"
    },
    {
      "Date": "2025-03-20",
      "Check In": "09:03 AM",
      "Check Out": "05:00 PM",
      "Status": "On-Time"
    },
    {
      "Date": "2025-03-21",
      "Check In": "09:00 AM",
      "Check Out": "05:00 PM",
      "Status": "On-Time"
    },
    {
      "Date": "2025-03-22",
      "Check In": "09:00 AM",
      "Check Out": "01:00 PM",
      "Status": "On-Time"
    },
    {
      "Date": "2025-03-23",
      "Check In": "-",
      "Check Out": "-",
      "Status": "Weekly Off"
    },
  ];
  late TabController _tabController;

  int leaveDays = 2;
  int presentDays = 18;
  int absentDays = 1;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeCameras() async {
    cameras = await availableCameras();
    setState(() {});
  }

  Future<void> _handleAttendance() async {
    bool isAtCorrectLocation = await GPSHelper.checkLocation();
    if (!isAtCorrectLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You are not at the correct location!")),
      );
      return;
    }

    TimeOfDay now = TimeOfDay.now();
    int currentMinutes = now.hour * 60 + now.minute;
    int startMinutes = 9 * 60;
    int endOnTimeMinutes = 9 * 60 + 15;
    int checkOutTimeLimit = 17 * 60;

    if (!isCheckedIn) {
      await _openCamera();
      if (isCheckedIn) {
        checkInTime = DateFormat('hh:mm a').format(DateTime.now());
        if (currentMinutes <= endOnTimeMinutes) {
          status = "On-Time";
        } else {
          status = "Late";
        }
        var newEntry = {
          "Date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "Check In": checkInTime ?? "-",
          "Check Out": "-",
          "Status": status ?? "-"
        };
        attendanceHistory.add(newEntry);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Checked in at $checkInTime ($status)")),
        );
      }
    } else {
      if (currentMinutes < checkOutTimeLimit) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Check-Out is only allowed at 5:00 PM!")),
        );
        return;
      }
      await _openCamera();
      if (!isCheckedIn) {
        checkOutTime = DateFormat('hh:mm a').format(DateTime.now());
        attendanceHistory.last["Check Out"] = checkOutTime!;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Checked out successfully at $checkOutTime")),
        );
      }
    }
  }

  Future<void> _openCamera() async {
    if (cameras == null || cameras!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No camera found!")),
      );
      return;
    }

    var status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission denied!")),
      );
      return;
    }

    CameraController cameraController = CameraController(
      cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front),
      ResolutionPreset.medium,
    );
    await cameraController.initialize();

    bool faceDetected = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FaceRecognitionScreen(cameraController)),
    );

    if (faceDetected) {
      setState(() {
        isCheckedIn = !isCheckedIn;
      });
    }

    await cameraController.dispose();
  }

  void _showAttendanceViewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Attendance View'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Weekly View'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showWeeklyAttendance();
                },
              ),
              ListTile(
                title: Text('Monthly View'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showMonthlyAttendance();
                },
              ),
              ListTile(
                title: Text('Overall View'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showOverallAttendance();
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showWeeklyAttendance() {
    List<Map<String, String>> weeklyData = attendanceHistory.where((record) {
      DateTime entryDate = DateTime.parse(record["Date"]!);
      DateTime now = DateTime.now();
      return now.difference(entryDate).inDays <= 7;
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AttendanceViewScreen(attendanceData: weeklyData, title: "Weekly Attendance"),
      ),
    );
  }

  void _showMonthlyAttendance() {
    List<Map<String, String>> monthlyData = attendanceHistory.where((record) {
      DateTime entryDate = DateTime.parse(record["Date"]!);
      DateTime now = DateTime.now();
      return entryDate.month == now.month && entryDate.year == now.year;
    }).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AttendanceViewScreen(attendanceData: monthlyData, title: "Monthly Attendance"),
      ),
    );
  }

  void _showOverallAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AttendanceViewScreen(attendanceData: attendanceHistory, title: "Overall Attendance"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Summary"),
            Tab(text: "Check In"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildCheckInTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            DateFormat('yyyy MMMM').format(DateTime.now()),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryCard("Leave Days", leaveDays),
            _buildSummaryCard("Present Days", presentDays),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryCard("Absent Days", absentDays),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _showAttendanceViewDialog,
            child: Text("Attendance View"),
          ),
        ),
        ListTile(
          title: Text("Weekly Off"),
          subtitle: Text("Sunday\nAll Sunday"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Attendance History",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text("Date")),
              DataColumn(label: Text("Check In")),
              DataColumn(label: Text("Check Out")),
              DataColumn(label: Text("Status")),
            ],
            rows: attendanceHistory.map((record) {
              return DataRow(cells: [
                DataCell(Text(record["Date"] ?? "-")),
                DataCell(Text(record["Check In"] ?? "-")),
                DataCell(Text(record["Check Out"] ?? "-")),
                DataCell(Text(record["Status"] ?? "-")),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInTab() {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: _handleAttendance,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCheckedIn ? Colors.green : Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
            ),
            child: Text(
              isCheckedIn ? "Check Out" : "Check In",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Check In")),
                DataColumn(label: Text("Check Out")),
                DataColumn(label: Text("Status")),
              ],
              rows: attendanceHistory.map((record) {
                return DataRow(cells: [
                  DataCell(Text(record["Date"] ?? "-")),
                  DataCell(Text(record["Check In"] ?? "-")),
                  DataCell(Text(record["Check Out"] ?? "-")),
                  DataCell(Text(record["Status"] ?? "-")),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
