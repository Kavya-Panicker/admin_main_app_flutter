import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(HRDocumentsApp());
}

class HRDocumentsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HRDocumentsScreen(),
    );
  }
}

class HRDocumentsScreen extends StatefulWidget {
  @override
  _HRDocumentsScreenState createState() => _HRDocumentsScreenState();
}

class _HRDocumentsScreenState extends State<HRDocumentsScreen> {
  List<Map<String, String>> documents = [
    {
      'title': 'Offer Letter - John Doe',
      'content': 'Dear John Doe, we are pleased to offer you the role of Software Engineer...\n\nTerms and Conditions:\n- Salary: \$6000/month\n- Work Location: Remote\n- Joining Date: 1st September 2024\n\nBest Regards,\nHR Team'
    },
    {
      'title': 'Salary Slip - Jane Smith',
      'content': 'Salary for the month of August 2024:\n\nBase Salary: \$5000\nDeductions: \$200\nNet Pay: \$4800\n\nPayment Date: 5th September 2024\n\nFor queries, contact HR.'
    },
    {
      'title': 'Company Policy Handbook',
      'content': 'Welcome to our company! This handbook contains our policies, code of conduct...\n\n- Work Hours: 9 AM - 5 PM\n- Leave Policy: 20 Annual Leaves\n- Grievance Redressal System\n\nFor full details, contact HR.'
    },
  ];

  /// Function to request storage permission
  Future<bool> _requestPermission() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Function to save file in Downloads folder
  Future<void> _downloadDocument(String title, String content) async {
    if (!await _requestPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied!')),
      );
      return;
    }

    Directory? downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      downloadsDir = await getExternalStorageDirectory();
    }

    final file = File('${downloadsDir!.path}/$title.txt');
    await file.writeAsString(content);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Document saved in: ${file.path}')),
    );
  }

  void _showDocumentDetail(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          height: 300, // Set fixed height to allow scrolling
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(content),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () => _downloadDocument(title, content),
            icon: Icon(Icons.download),
            label: Text("Download"),
          ),
        ],
      ),
    );
  }

  void _addNewDocument() {
    setState(() {
      documents.insert(0, {
        'title': 'New Policy Update',
        'content': 'This document contains the latest HR policy updates for employees...\n\n- New Work-From-Home Policy\n- Updated Leave Benefits\n- Performance Bonus Structure\n\nFor details, reach out to HR.'
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HR Documents")),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.description, color: Colors.blueAccent),
            title: Text(documents[index]['title']!),
            onTap: () => _showDocumentDetail(
              documents[index]['title']!,
              documents[index]['content']!,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewDocument,
      ),
    );
  }
}
