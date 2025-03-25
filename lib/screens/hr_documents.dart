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
 

 class _HRDocumentsScreenState extends State<HRDocumentsScreen>
  with SingleTickerProviderStateMixin {
  late TabController _tabController;
 

  final List<Map<String, String>> myDocuments = [
   {
    'title': 'Offer Letter - John Doe',
    'content': 'Dear John Doe, we are pleased to offer you a role....'
   },
   {
    'title': 'Salary Slip - Jane Smith',
    'content': 'Salary details for August 2024...'
   },
   {
    'title': 'Company Policy Handbook',
    'content': 'Welcome! This handbook contains our policies...'
   },
  ];
 

  final List<Map<String, String>> hrPolicies = [
   {
    'title': 'General Rules',
    'content': 'Updated employee codes and guidelines.',
    'lastUpdated': '04-10-2024'
   },
   {
    'title': 'Leave Policy',
    'content': 'Latest leave policy details.',
    'lastUpdated': '01-09-2024'
   },
   {
    'title': 'Remote Work Policy',
    'content': 'Work-from-home policy guidelines.',
    'lastUpdated': '15-08-2024'
   },
  ];
 

  @override
  void initState() {
   super.initState();
   _tabController = TabController(length: 2, vsync: this);
  }
 

  @override
  void dispose() {
   _tabController.dispose();
   super.dispose();
  }
 

  Future<bool> _requestPermission() async {
   var status = await Permission.storage.request();
   return status.isGranted;
  }
 

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
 

  void _showDocumentDetail(String title, String content, {bool isHRPolicy = false, String? lastUpdated}) {
   showDialog(
    context: context,
    builder: (context) => AlertDialog(
     title: Text(title),
     content: Container(
      height: 300, // Set fixed height for scrolling
      width: double.maxFinite,
      child: SingleChildScrollView(
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         if (isHRPolicy)
          Text(
           "Last Updated On: $lastUpdated",
           style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
         SizedBox(height: 10),
         Text(content),
        ],
       ),
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
 

  void _addNewDocument() async {
   final result = await showDialog(
    context: context,
    builder: (context) => AddDocumentDialog(),
   );
 

   if (result != null && result is Map<String, String>) {
    setState(() {
     myDocuments.add(result);
    });
   }
  }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
     title: Text("HR Documents"),
     bottom: TabBar(
      controller: _tabController,
      tabs: [
       Tab(text: 'My Documents'),
       Tab(text: 'HR Policies'),
      ],
     ),
    ),
    body: TabBarView(
     controller: _tabController,
     children: [
      _buildMyDocumentsTab(),
      _buildHRPoliciesTab(),
     ],
    ),
    floatingActionButton: FloatingActionButton(
     child: Icon(Icons.add),
     onPressed: _addNewDocument,
     tooltip: 'Add New Document',
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
   );
  }
 

  Widget _buildMyDocumentsTab() {
   return ListView.builder(
    itemCount: myDocuments.length,
    itemBuilder: (context, index) {
     return ListTile(
      leading: Icon(Icons.description, color: Colors.blueAccent),
      title: Text(myDocuments[index]['title']!),
      onTap: () => _showDocumentDetail(
       myDocuments[index]['title']!,
       myDocuments[index]['content']!,
      ),
     );
    },
   );
  }
 

  Widget _buildHRPoliciesTab() {
   return ListView.builder(
    itemCount: hrPolicies.length,
    itemBuilder: (context, index) {
     return ListTile(
      leading: Icon(Icons.picture_as_pdf, color: Colors.red),
      title: Text(hrPolicies[index]['title']!),
      subtitle: Text("Last Updated On: ${hrPolicies[index]['lastUpdated']}"),
      onTap: () => _showDocumentDetail(
       hrPolicies[index]['title']!,
       hrPolicies[index]['content']!,
       isHRPolicy: true,
       lastUpdated: hrPolicies[index]['lastUpdated'],
      ),
     );
    },
   );
  }
 }
 

 class AddDocumentDialog extends StatefulWidget {
  @override
  _AddDocumentDialogState createState() => _AddDocumentDialogState();
 }
 

 class _AddDocumentDialogState extends State<AddDocumentDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
 

  @override
  Widget build(BuildContext context) {
   return AlertDialog(
    title: Text("Add New Document"),
    content: SingleChildScrollView(
     child: Column(
      children: [
       TextField(
        controller: _titleController,
        decoration: InputDecoration(labelText: "Title"),
       ),
       TextField(
        controller: _contentController,
        decoration: InputDecoration(labelText: "Content"),
        maxLines: 5,
       ),
      ],
     ),
    ),
    actions: [
     TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text("Cancel"),
     ),
     ElevatedButton(
      onPressed: () {
       final title = _titleController.text;
       final content = _contentController.text;
       if (title.isNotEmpty && content.isNotEmpty) {
        Navigator.pop(context, {'title': title, 'content': content});
       }
      },
      child: Text("Add"),
     ),
    ],
   );
  }
 

  @override
  void dispose() {
   _titleController.dispose();
   _contentController.dispose();
   super.dispose();
  }
 }
