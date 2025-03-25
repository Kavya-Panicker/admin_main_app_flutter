import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../utils/gps_helper.dart';
import 'face_recognition_screen.dart';
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
  List<Map<String, String>> attendanceHistory = [];
  late TabController _tabController;

  int leaveDays = 0;
  int presentDays = 20;
  int absentDays = 0;

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
        attendanceHistory.add({
          "Date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "Check In": checkInTime!,
          "Status": status!
        });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
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
            onPressed: () {},
            child: Text("Attendance view"),
          ),
        ),
        ListTile(
          title: Text("Clock in priority"),
          subtitle: Text("Biometric"),
        ),
        ListTile(
          title: Text("Shift"),
          subtitle: Text("General Shift-3 Regularization Limit\n10:00 - 19:00"),
        ),
        ListTile(
          title: Text("Policy"),
          subtitle: Text("ATTENDANCE POLICY- 3 REGULARIZATION LIMIT",
              style: TextStyle(color: Colors.blue)),
        ),
        ListTile(
          title: Text("Weekly Off"),
          subtitle: Text("Sunday\nAll Sunday"),
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

