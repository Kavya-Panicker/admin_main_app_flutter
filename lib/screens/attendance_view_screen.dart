import 'package:flutter/material.dart';

class AttendanceViewScreen extends StatelessWidget {
  final List<Map<String, String>> attendanceData;
  final String title;

  AttendanceViewScreen({required this.attendanceData, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text("Date")),
            DataColumn(label: Text("Check In")),
            DataColumn(label: Text("Check Out")),
            DataColumn(label: Text("Status")),
          ],
          rows: attendanceData.map((record) {
            return DataRow(cells: [
              DataCell(Text(record["Date"] ?? "-")),
              DataCell(Text(record["Check In"] ?? "-")),
              DataCell(Text(record["Check Out"] ?? "-")),
              DataCell(Text(record["Status"] ?? "-")),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
