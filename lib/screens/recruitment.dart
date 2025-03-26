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
    // Pass a COPY of the job data to avoid modifying the original directly
    Map<String, String>? jobToEdit = job != null ? Map.from(job) : null;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditJobScreen(job: jobToEdit),
      ),
    );

    // Check if result is null BEFORE proceeding
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
        // Safely access job data using null-aware operators
        final job = jobs[index];
        final title = job["title"] ?? "No Title";
        final location = job["location"] ?? "No Location";

        return Card(
          child: ListTile(
            title: Text(title),
            subtitle: Text(location),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /*IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  // Pass the job, even if it might have null values
                  onPressed: () => _addOrEditJob(job: job, index: index),
                ),*/
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyInterviewScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text("Refer"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReferScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.swap_horiz),
            title: Text("Internal Job Movement"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InternalJobMovementScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MyInterviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Interview"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upcoming Interviews:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListTile(
              title: Text("Flutter Developer Interview"),
              subtitle: Text("Date: 2024-09-15, Time: 10:00 AM"),
              leading: Icon(Icons.event),
            ),
            ListTile(
              title: Text("Backend Engineer Interview"),
              subtitle: Text("Date: 2024-09-16, Time: 02:00 PM"),
              leading: Icon(Icons.event),
            ),
            SizedBox(height: 20),
            Text("Past Interviews:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ListTile(
              title: Text("UI/UX Designer Interview"),
              subtitle: Text("Date: 2024-08-28, Result: Passed"),
              leading: Icon(Icons.history),
            ),
          ],
        ),
      ),
    );
  }
}

class ReferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer a Candidate"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Know someone who'd be a great fit?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Enter their details below to refer them for a position."),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "Candidate's Name"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Candidate's Email"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Position Referred For"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement referral logic here
              },
              child: Text("Submit Referral"),
            ),
          ],
        ),
      ),
    );
  }
}

class InternalJobMovementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Internal Job Movement"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Explore Internal Opportunities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Looking for a new challenge within the company? Check out these open positions:"),
            SizedBox(height: 20),
            ListTile(
              title: Text("Senior Flutter Developer"),
              subtitle: Text("Department: Mobile Engineering"),
              leading: Icon(Icons.work),
            ),
            ListTile(
              title: Text("Lead Backend Engineer"),
              subtitle: Text("Department: Server Infrastructure"),
              leading: Icon(Icons.work),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement application logic here
              },
              child: Text("Apply for a Position"),
            ),
          ],
        ),
      ),
    );
  }
}
