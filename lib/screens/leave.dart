import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LeaveScreen extends StatefulWidget {
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final List<String> leaveTypes = ["Sick Leave", "Casual Leave", "Paid Leave", "Half Day"];
  String? selectedLeaveType;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController reasonController = TextEditingController();

  List<Map<String, String>> leaveRequests = [];

  @override
  void initState() {
    super.initState();
    _loadLeaveHistory(); // Load past leave history
  }

  // Load Leave History from SharedPreferences
  Future<void> _loadLeaveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedLeaves = prefs.getString("leaveHistory");

    if (storedLeaves != null) {
      setState(() {
        leaveRequests = List<Map<String, String>>.from(jsonDecode(storedLeaves));
      });
    }
  }

  // Save Leave History to SharedPreferences
  Future<void> _saveLeaveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("leaveHistory", jsonEncode(leaveRequests));
  }

  // Date Picker Function
  void _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = startDate;
          }
        } else {
          endDate = pickedDate;
          if (startDate != null && endDate!.isBefore(startDate!)) {
            startDate = endDate;
          }
        }
      });
    }
  }

  // Apply for Leave
  void _applyLeave() {
    if (selectedLeaveType == null || startDate == null || endDate == null || reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      leaveRequests.add({
        "type": selectedLeaveType!,
        "from": "${startDate!.day}-${startDate!.month}-${startDate!.year}",
        "to": "${endDate!.day}-${endDate!.month}-${endDate!.year}",
        "reason": reasonController.text,
        "status": "Pending",
      });

      selectedLeaveType = null;
      startDate = null;
      endDate = null;
      reasonController.clear();
    });

    _saveLeaveHistory(); // Save the updated leave history

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Leave Applied Successfully!"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leave Application")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Apply for Leave", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Leave Type Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              value: selectedLeaveType,
              hint: Text("Select Leave Type"),
              onChanged: (value) => setState(() => selectedLeaveType = value),
              items: leaveTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
            ),
            SizedBox(height: 10),

            // Date Pickers
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: "From Date"),
                      child: Text(startDate == null ? "Select Date" : "${startDate!.day}-${startDate!.month}-${startDate!.year}"),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: "To Date"),
                      child: Text(endDate == null ? "Select Date" : "${endDate!.day}-${endDate!.month}-${endDate!.year}"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Reason Input
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Reason"),
            ),
            SizedBox(height: 10),

            // Apply Button
            Center(
              child: ElevatedButton(
                onPressed: _applyLeave,
                child: Text("Apply Leave"),
              ),
            ),

            SizedBox(height: 20),
            Divider(),

            // Leave History
            Text("Leave History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: leaveRequests.isEmpty
                  ? Center(child: Text("No Leave Records Found"))
                  : ListView.builder(
                      itemCount: leaveRequests.length,
                      itemBuilder: (context, index) {
                        var leave = leaveRequests[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            title: Text("${leave["type"]} Leave (${leave["from"]} - ${leave["to"]})"),
                            subtitle: Text("Reason: ${leave["reason"]}"),
                            trailing: Text(
                              leave["status"]!,
                              style: TextStyle(
                                color: leave["status"] == "Pending" ? Colors.orange : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
