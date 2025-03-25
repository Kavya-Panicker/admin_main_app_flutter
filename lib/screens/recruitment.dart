 import 'package:flutter/material.dart';
 import 'add_edit_job_screen.dart';
 

 class RecruitmentScreen extends StatefulWidget {
  @override
  _RecruitmentScreenState createState() => _RecruitmentScreenState();
 }
 

 class _RecruitmentScreenState extends State<RecruitmentScreen> {
  int _selectedIndex = 0;
  List<Map<String, String>> jobs = [
   {"title": "Flutter Developer", "location": "Remote"},
   {"title": "Backend Engineer", "location": "Onsite - New York"},
   {"title": "UI/UX Designer", "location": "Onsite - California"},
  ];
 

  void _addOrEditJob({Map<String, String>? job, int? index}) async {
   final result = await Navigator.push(
    context,
    MaterialPageRoute(
     builder: (context) => AddEditJobScreen(job: job),
    ),
   );
 

   if (result != null) {
    setState(() {
     if (index != null) {
      jobs[index] = result; // Edit existing job
     } else {
      jobs.add(result); // Add new job
     }
    });
   }
  }
 

  void _deleteJob(int index) {
   setState(() {
    jobs.removeAt(index);
   });
 

   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Job deleted successfully!")),
   );
  }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(title: Text("Admin Recruitment Panel")),
    body: _selectedIndex == 0 ? _buildRecruitmentList() : _buildReferralList(),
    floatingActionButton: _selectedIndex == 0
     ? FloatingActionButton(
      onPressed: () => _addOrEditJob(),
      child: Icon(Icons.add),
      backgroundColor: Colors.blue,
     )
     : null,
    bottomNavigationBar: BottomNavigationBar(
     items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
       icon: Icon(Icons.work),
       label: 'Recruitment',
      ),
      BottomNavigationBarItem(
       icon: Icon(Icons.people),
       label: 'Referrals',
      ),
     ],
     currentIndex: _selectedIndex,
     selectedItemColor: Colors.blue,
     onTap: (index) {
      setState(() {
       _selectedIndex = index;
      });
     },
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
   );
  }
 

  Widget _buildRecruitmentList() {
   return ListView.builder(
    itemCount: jobs.length,
    itemBuilder: (context, index) {
     return Card(
      child: ListTile(
       title: Text(jobs[index]["title"]!),
       subtitle: Text(jobs[index]["location"]!),
       trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _addOrEditJob(job: jobs[index], index: index),
         ),
         IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteJob(index),
         ),
        ],
       ),
      ),
     );
    },
   );
  }
 

  Widget _buildReferralList() {
   return Card(
    margin: EdgeInsets.all(8.0),
    child: Column(
     children: <Widget>[
      ListTile(
       leading: Icon(Icons.work),
       title: Text("My Interview"),
       trailing: Icon(Icons.arrow_forward_ios),
       onTap: () {
        // Handle navigation or action
       },
      ),
      Divider(),
      ListTile(
       leading: Icon(Icons.person_add),
       title: Text("Refer"),
       trailing: Icon(Icons.arrow_forward_ios),
       onTap: () {
        // Handle navigation or action
       },
      ),
      Divider(),
      ListTile(
       leading: Icon(Icons.swap_horiz),
       title: Text("Internal Job Movement"),
       trailing: Icon(Icons.arrow_forward_ios),
       onTap: () {
        // Handle navigation or action
       },
      ),
     ],
    ),
   );
  }
 }
