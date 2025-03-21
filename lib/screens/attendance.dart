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

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isCheckedIn = false;
  List<CameraDescription>? cameras;
  String? checkInTime;
  String? checkOutTime;
  String? status;
  List<Map<String, String>> attendanceHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeCameras();
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
        attendanceHistory.add({"Date": DateFormat('yyyy-MM-dd').format(DateTime.now()), "Check In": checkInTime!, "Status": status!});
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
      cameras!.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front),
      ResolutionPreset.medium,
    );
    await cameraController.initialize();

    bool faceDetected = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FaceRecognitionScreen(cameraController)),
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
      appBar: AppBar(title: Text("Attendance")),
      body: Column(
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
      ),
    );
  }
}
