import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TaskBoxScreen(),
  ));
}

class TaskBoxScreen extends StatefulWidget {
  @override
  _TaskBoxScreenState createState() => _TaskBoxScreenState();
}

class _TaskBoxScreenState extends State<TaskBoxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  List<Map<String, dynamic>> tasks = [
    {
      "employee": "John Doe",
      "task": "Fix login issue",
      "taskType": "Bug Fix",
      "description": "Resolve the login bug.",
      "completed": false,
      "deadline": DateTime.now().add(Duration(days: 2))
    },
    {
      "employee": "Emma Watson",
      "task": "Design homepage UI",
      "taskType": "UI/UX",
      "description": "Create a homepage design.",
      "completed": true,
      "deadline": DateTime.now().add(Duration(days: 5))
    },
    {
      "employee": "Michael Scott",
      "task": "Database Migration",
      "taskType": "Database",
      "description": "Migrate to PostgreSQL.",
      "completed": false,
      "deadline": DateTime.now().add(Duration(days: 4))
    },
    {
      "employee": "Jane Smith",
      "task": "Implement search functionality",
      "taskType": "Feature Development",
      "description": "Add search to main page",
      "completed": false,
      "deadline": DateTime.now().add(Duration(days: 7))
    },
    {
      "employee": "Robert Jones",
      "task": "Write API documentation",
      "taskType": "Documentation",
      "description": "Document all API endpoints",
      "completed": true,
      "deadline": DateTime.now().add(Duration(days: 3))
    },
    {
      "employee": "Emily White",
      "task": "Conduct user testing",
      "taskType": "Testing",
      "description": "Gather feedback from users",
      "completed": false,
      "deadline": DateTime.now().add(Duration(days: 6))
    },
    {
      "employee": "David Brown",
      "task": "Optimize database queries",
      "taskType": "Performance",
      "description": "Improve database speed",
      "completed": true,
      "deadline": DateTime.now().add(Duration(days: 1))
    },
    {
      "employee": "Linda Green",
      "task": "Update security protocols",
      "taskType": "Security",
      "description": "Enhance application security",
      "completed": false,
      "deadline": DateTime.now().add(Duration(days: 8))
    },
    {
      "employee": "Kevin Black",
      "task": "Refactor old code",
      "taskType": "Maintenance",
      "description": "Clean up legacy code",
      "completed": true,
      "deadline": DateTime.now().add(Duration(days: 2))
    },
    {
      "employee": "Ashley Grey",
      "task": "Integrate payment gateway",
      "taskType": "Integration",
      "description": "Connect to Stripe API",
      "completed": false,
      "deadline": DateTime.now().add(Duration(days: 9))
    }
  ];

  List<Map<String, dynamic>> getAssignedTasks() {
    return tasks.where((task) => !task["completed"]).toList();
  }

  List<Map<String, dynamic>> getRaisedTasks() {
    return tasks; // Placeholder; replace with logic for "Raised by me"
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String taskName = '';
        String taskDescription = '';
        String assignedTo = '';
        DateTime? assignedDate;
        DateTime? submissionDate;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Add New Task'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(hintText: "Task Name"),
                      onChanged: (value) => taskName = value,
                    ),
                    TextField(
                      decoration:
                          InputDecoration(hintText: "Task Description"),
                      onChanged: (value) => taskDescription = value,
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "Assign To"),
                      onChanged: (value) => assignedTo = value,
                    ),
                    ListTile(
                      title: Text(
                        assignedDate == null
                            ? 'Select Assign Date'
                            : 'Assign Date: ${assignedDate!.toLocal()}'.split(' ')[0],
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2026),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            assignedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text(
                        submissionDate == null
                            ? 'Select Submission Date'
                            : 'Submission Date: ${submissionDate!.toLocal()}'.split(' ')[0],
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2026),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            submissionDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    setState(() {
                      tasks.add({
                        "employee": assignedTo,
                        "task": taskName,
                        "taskType": "Custom",
                        "description": taskDescription,
                        "completed": false,
                        "deadline": submissionDate ?? DateTime.now(),
                      });
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openTaskDetails(Map<String, dynamic> task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Box"),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        elevation: 0,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Assigned to me (${getAssignedTasks().length})"),
              Tab(text: "Raised by me (${getRaisedTasks().length})"),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Assigned to me
                if (getAssignedTasks().isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://placehold.co/200x150",
                          width: 150,
                          height: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No tasks assigned to you yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "Check back here for future assignments.",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    itemCount: getAssignedTasks().length,
                    itemBuilder: (context, index) {
                      final task = getAssignedTasks()[index];
                      return ListTile(
                        title: Text(task["task"]),
                        subtitle: Text("Assigned to: ${task["employee"]}"),
                        onTap: () => _openTaskDetails(task),
                      );
                    },
                  ),

                // Raised by me
                if (getRaisedTasks().isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://placehold.co/200x150",
                          width: 150,
                          height: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No tasks assigned to you yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "Check back here for future assignments.",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    itemCount: getRaisedTasks().length,
                    itemBuilder: (context, index) {
                      final task = getRaisedTasks()[index];
                      return ListTile(
                        title: Text(task["task"]),
                        subtitle: Text("Assigned to: ${task["employee"]}"),
                        onTap: () => _openTaskDetails(task),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task["task"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Assigned to: ${task["employee"]}"),
            SizedBox(height: 10),
            Text("Task Type: ${task["taskType"]}"),
            SizedBox(height: 10),
            Text("Description: ${task["description"]}"),
            SizedBox(height: 10),
            Text("Deadline: ${task["deadline"].toString()}"),
            SizedBox(height: 10),
            Text("Completed: ${task["completed"] ? 'Yes' : 'No'}"),
          ],
        ),
      ),
    );
  }
}
