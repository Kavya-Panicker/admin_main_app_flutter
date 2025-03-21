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

class _TaskBoxScreenState extends State<TaskBoxScreen> {
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
  ];

  void _addOrEditTask({Map<String, dynamic>? task}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
    );

    if (result != null) {
      setState(() {
        if (task != null) {
          int index = tasks.indexOf(task);
          tasks[index] = result;
        } else {
          tasks.insert(0, result);
        }
      });
    }
  }

  void _navigateToTaskList(BuildContext context, int filterType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListScreen(tasks: tasks, filterType: filterType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Box"),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Icon(
                task["completed"] ? Icons.check_circle : Icons.pending_actions,
                color: task["completed"] ? Colors.green : Colors.orange,
              ),
              title: Text(task["task"], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Assigned to: ${task["employee"]}\nDeadline: ${task["deadline"]}"),
              trailing: Icon(Icons.edit, color: Colors.blue),
              onTap: () => _addOrEditTask(task: task),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _navigateToTaskList(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle, color: Colors.green),
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions, color: Colors.orange),
            label: "Pending",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Colors.blue),
            label: "Assigned",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditTask(),
        child: Icon(Icons.add_task_rounded),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class TaskFormScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String employee = "";
  String taskTitle = "";
  String taskType = "";
  String description = "";
  bool completed = false;
  DateTime deadline = DateTime.now().add(Duration(days: 5));

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      employee = widget.task!["employee"];
      taskTitle = widget.task!["task"];
      taskType = widget.task!["taskType"];
      description = widget.task!["description"];
      completed = widget.task!["completed"];
      deadline = widget.task!["deadline"];
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> newTask = {
        "employee": employee,
        "task": taskTitle,
        "taskType": taskType,
        "description": description,
        "completed": completed,
        "deadline": deadline,
      };
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? "Add Task" : "Edit Task")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: employee,
                decoration: InputDecoration(labelText: "Employee Name"),
                onChanged: (value) => employee = value,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                initialValue: taskTitle,
                decoration: InputDecoration(labelText: "Task Title"),
                onChanged: (value) => taskTitle = value,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                initialValue: taskType,
                decoration: InputDecoration(labelText: "Task Type"),
                onChanged: (value) => taskType = value,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: "Description"),
                onChanged: (value) => description = value,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              Row(
                children: [
                  Text("Completed"),
                  Switch(
                    value: completed,
                    onChanged: (value) => setState(() => completed = value),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Save Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final int filterType;

  TaskListScreen({required this.tasks, required this.filterType});

  List<Map<String, dynamic>> _getFilteredTasks() {
    if (filterType == 0) {
      return tasks.where((task) => task["completed"]).toList();
    } else if (filterType == 1) {
      return tasks.where((task) => !task["completed"]).toList();
    } else {
      return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks = _getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text(filterType == 0 ? "Completed Tasks" : filterType == 1 ? "Pending Tasks" : "Assigned Tasks"),
      ),
      body: filteredTasks.isEmpty
          ? Center(child: Text("No tasks found."))
          : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return ListTile(
                  title: Text(task["task"]),
                  subtitle: Text("Assigned to: ${task["employee"]}"),
                );
              },
            ),
    );
  }
}
