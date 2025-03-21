 import 'package:flutter/material.dart';
 

 void main() {
  runApp(MyApp());
 }
 

 class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    title: 'Employee Management App',
    theme: ThemeData(
     primarySwatch: Colors.blue,
     visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: EmployeeScreen(),
   );
  }
 }
 

 class Task {
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;
 

  Task({
   required this.title,
   required this.description,
   required this.dueDate,
   this.isCompleted = false,
  });
 

  Task copyWith({
   String? title,
   String? description,
   DateTime? dueDate,
   bool? isCompleted,
  }) {
   return Task(
    title: title ?? this.title,
    description: description ?? this.description,
    dueDate: dueDate ?? this.dueDate,
    isCompleted: isCompleted ?? this.isCompleted,
   );
  }
 }
 

 class LeaveRequest {
  DateTime startDate;
  DateTime endDate;
  String reason;
  String status; // 'pending', 'approved', 'rejected'
  String leaveType; // 'casual', 'annual', 'sick'
 

  LeaveRequest({
   required this.startDate,
   required this.endDate,
   required this.reason,
   required this.leaveType,
   this.status = 'pending',
  });
 }
 

 class Employee {
  final String name;
  final String role;
  final String profilePic;
  final String email;
  final String department;
  final String about;
  List<Task> tasks;
  List<LeaveRequest> leaveRequests;
 

  Employee({
   required this.name,
   required this.role,
   required this.profilePic,
   required this.email,
   required this.department,
   required this.about,
   this.tasks = const [],
   this.leaveRequests = const [],
  });
 

  Employee copyWith({
   String? name,
   String? role,
   String? profilePic,
   String? email,
   String? department,
   String? about,
   List<Task>? tasks,
   List<LeaveRequest>? leaveRequests,
  }) {
   return Employee(
    name: name ?? this.name,
    role: role ?? this.role,
    profilePic: profilePic ?? this.profilePic,
    email: email ?? this.email,
    department: department ?? this.department,
    about: about ?? this.about,
    tasks: tasks ?? this.tasks,
    leaveRequests: leaveRequests ?? this.leaveRequests,
   );
  }
 }
 

 class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
 }
 

 class _EmployeeScreenState extends State<EmployeeScreen> {
  List<Employee> employees = [
   Employee(
    name: "John Doe",
    role: "Software Engineer",
    profilePic: "https://randomuser.me/api/portraits/men/1.jpg",
    email: "john.doe@example.com",
    department: "IT",
    about: "Passionate about coding and technology.",
    tasks: [
     Task(
      title: "Implement Feature A",
      description: "Develop and test new user feature",
      dueDate: DateTime.now().add(Duration(days: 7)),
      isCompleted: true,
     ),
    ],
    leaveRequests: [
     LeaveRequest(
      startDate: DateTime.now().add(Duration(days: 10)),
      endDate: DateTime.now().add(Duration(days: 15)),
      reason: "Family Vacation",
      leaveType: "annual",
     ),
    ],
   ),
   Employee(
    name: "Jane Smith",
    role: "UI/UX Designer",
    profilePic: "https://randomuser.me/api/portraits/women/2.jpg",
    email: "jane.smith@example.com",
    department: "Design",
    about: "Loves creating intuitive user experiences.",
   ),
   Employee(
    name: "Michael Brown",
    role: "HR Manager",
    profilePic: "https://randomuser.me/api/portraits/men/3.jpg",
    email: "michael.brown@example.com",
    department: "Human Resources",
    about: "Ensuring a great workplace culture.",
   ),
   Employee(
    name: "Alice Johnson",
    role: "Finance Analyst",
    profilePic: "https://randomuser.me/api/portraits/women/4.jpg",
    email: "alice.johnson@example.com",
    department: "Finance",
    about: "Loves analyzing company growth metrics.",
   ),
  ];
 

  List<Employee> filteredEmployees = [];
  TextEditingController searchController = TextEditingController();
 

  @override
  void initState() {
   super.initState();
   filteredEmployees = employees;
   searchController.addListener(_filterEmployees);
  }
 

  void _filterEmployees() {
   String query = searchController.text.toLowerCase();
   setState(() {
    filteredEmployees = employees.where((employee) {
     return employee.name.toLowerCase().contains(query) ||
       employee.role.toLowerCase().contains(query);
    }).toList();
   });
  }
 

  void _addEmployee(BuildContext context) async {
   final newEmployee = await Navigator.push(
    context,
    MaterialPageRoute(
     builder: (context) =>
       EmployeeEditScreen(employee: null, isNew: true, onDelete: null,)),
   );
 

   if (newEmployee != null) {
    setState(() {
     employees.add(newEmployee);
     filteredEmployees = employees;
    });
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: Text('Employee added successfully!')),
    );
   }
  }
 

  void _editEmployee(BuildContext context, Employee employee, int index, Function() onDelete) async {
    final updatedEmployee = await Navigator.push(
     context,
     MaterialPageRoute(
      builder: (context) => EmployeeEditScreen(employee: employee, isNew: false, onDelete: onDelete),
     ),
    );
 

    if (updatedEmployee != null) {
     setState(() {
      employees[index] = updatedEmployee;
      filteredEmployees = employees;
     });
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Employee updated successfully!')),
     );
    }
   }
 

  // void _deleteEmployee(BuildContext context, Employee employee) {
  //  showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //    return AlertDialog(
  //     title: Text("Confirm Delete"),
  //     content: Text("Are you sure you want to delete ${employee.name}?"),
  //     actions: <Widget>[
  //      TextButton(
  //       child: Text("Cancel"),
  //       onPressed: () {
  //        Navigator.of(context).pop();
  //       },
  //      ),
  //      TextButton(
  //       child: Text("Delete", style: TextStyle(color: Colors.red)),
  //       onPressed: () {
  //        setState(() {
  //         employees.remove(employee);
  //         filteredEmployees = employees;
  //        });
  //        Navigator.of(context).pop();
  //        ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Employee deleted successfully!')),
  //        );
  //       },
  //      ),
  //     ],
  //    );
  //   },
  //  );
  // }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(title: Text("Employees")),
    body: Padding(
     padding: const EdgeInsets.all(8.0),
     child: Column(
      children: [
       TextField(
        controller: searchController,
        decoration: InputDecoration(
         hintText: "Search by name or role...",
         prefixIcon: Icon(Icons.search),
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
       ),
       SizedBox(height: 10),
       Expanded(
        child: GridView.builder(
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
         ),
         itemCount: filteredEmployees.length,
         itemBuilder: (context, index) {
          var employee = filteredEmployees[index];
          return GestureDetector(
           onTap: () {
            Navigator.push(
             context,
             MaterialPageRoute(
              builder: (context) =>
                EmployeeProfileScreen(employee: employee, onEmployeeUpdated: (Employee updatedEmployee) {
                 setState(() {
                  employees[index] = updatedEmployee;
                  filteredEmployees = employees;
                 });
                },
                onEditPressed: () {
                     _editEmployee(context, employee, index, () {
                     setState(() {
                       employees.remove(employee);
                       filteredEmployees = employees;
                     });
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Employee deleted successfully!')),
                     );
                    });
                   },
                 ),
             ),
            );
           },
           child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(12)),
            child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
              SizedBox(height: 10),
              CircleAvatar(
               radius: 40,
               backgroundImage: NetworkImage(employee.profilePic),
              ),
              SizedBox(height: 10),
              Text(employee.name,
               style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 5),
              Text(employee.role,
               style: TextStyle(color: Colors.grey)),
             ],
            ),
           ),
          );
         },
        ),
       ),
      ],
     ),
    ),
    floatingActionButton: FloatingActionButton(
     onPressed: () => _addEmployee(context),
     child: Icon(Icons.add),
    ),
   );
  }
 

  @override
  void dispose() {
   searchController.removeListener(_filterEmployees);
   searchController.dispose();
   super.dispose();
  }
 }
 

 class EmployeeProfileScreen extends StatefulWidget {
  final Employee employee;
  final Function(Employee) onEmployeeUpdated;
  final Function() onEditPressed;
 

  EmployeeProfileScreen({required this.employee, required this.onEmployeeUpdated, required this.onEditPressed});
 

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
 }
 

 class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  late Employee employee;
  int _selectedIndex = 0;
 

  @override
  void initState() {
   super.initState();
   employee = widget.employee;
  }
 

  int get completedTasksCount {
   return employee.tasks.where((task) => task.isCompleted).length;
  }
 

  void _assignNewTask(BuildContext context) async {
   final newTask = await Navigator.push(
    context,
    MaterialPageRoute(
     builder: (context) => TaskAssignmentScreen(),
    ),
   );
 

   if (newTask != null) {
    setState(() {
     employee.tasks = [...employee.tasks, newTask];
     widget.onEmployeeUpdated(employee);
    });
   }
  }
 

  void _toggleTaskCompletion(Task task, bool? newValue) {
   if (newValue != null) {
    setState(() {
     task.isCompleted = newValue;
     widget.onEmployeeUpdated(employee);
    });
   }
  }
 

  void _updateLeaveRequestStatus(LeaveRequest request, String newStatus) {
   setState(() {
    request.status = newStatus;
    widget.onEmployeeUpdated(employee);
   });
  }
  
  // void _editEmployee(BuildContext context, Employee employee) async {
  //   final updatedEmployee = await Navigator.push(
  //    context,
  //    MaterialPageRoute(
  //     builder: (context) => EmployeeEditScreen(employee: employee),
  //    ),
  //   );
 

  //   if (updatedEmployee != null) {
  //    setState(() {
  //     employee = updatedEmployee;
  //     widget.onEmployeeUpdated(employee);
  //    });
  //    ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Employee updated successfully!')),
  //    );
  //   }
  //  }
 

  Widget _buildProfileView() {
   return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
      Center(
       child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(employee.profilePic),
       ),
      ),
      SizedBox(height: 15),
      Text(employee.name,
       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      Text(employee.role,
       style: TextStyle(fontSize: 18, color: Colors.grey[600])),
      Divider(),
      SizedBox(height: 10),
      Row(children: [
       Icon(Icons.email, color: Colors.blue),
       SizedBox(width: 10),
       Text(employee.email)
      ]),
      SizedBox(height: 10),
      Row(children: [
       Icon(Icons.business, color: Colors.green),
       SizedBox(width: 10),
       Text(employee.department)
      ]),
      SizedBox(height: 20),
      Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      Text(employee.about, style: TextStyle(fontSize: 16)),
     ],
    ),
   );
  }
 

  Widget _buildPayrollView() {
   return Center(
    child: Text('Payroll Information for ${employee.name} will be displayed here.'),
   );
  }
 

  Widget _buildTaskListView() {
   return Column(
    children: [
     Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text("Completed Tasks: $completedTasksCount", style: TextStyle(fontSize: 16)),
     ),
     Expanded(
      child: ListView.builder(
       itemCount: employee.tasks.length,
       itemBuilder: (context, index) {
        final task = employee.tasks[index];
        return Card(
         margin: EdgeInsets.all(8.0),
         child: ListTile(
          title: Text(task.title),
          subtitle: Text('Due Date: ${task.dueDate.toLocal()}'),
          trailing: Checkbox(
           value: task.isCompleted,
           onChanged: (bool? newValue) => _toggleTaskCompletion(task, newValue),
          ),
          onTap: () async {
           final updatedTask = await Navigator.push(
            context,
            MaterialPageRoute(
             builder: (context) => TaskDetailScreen(task: task),
            ),
           );
 

           if (updatedTask != null) {
            setState(() {
             employee.tasks[index] = updatedTask;
             widget.onEmployeeUpdated(employee);
            });
           }
          },
         ),
        );
       },
      ),
     ),
    ],
   );
  }
 

  Widget _buildLeaveView() {
   return ListView.builder(
    itemCount: employee.leaveRequests.length,
    itemBuilder: (context, index) {
     final request = employee.leaveRequests[index];
     return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          'Leave Request',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
         ),
         SizedBox(height: 10),
         Text('Start Date: ${request.startDate.toLocal()}'),
         Text('End Date: ${request.endDate.toLocal()}'),
         Text('Reason: ${request.reason}'),
         Text('Leave Type: ${request.leaveType}'), // Display leave type
         SizedBox(height: 10),
         Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
           if (request.status == 'pending')
            ElevatedButton(
             onPressed: () => _updateLeaveRequestStatus(request, 'approved'),
             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
             child: Text('Accept'),
            ),
           SizedBox(width: 10),
           if (request.status == 'pending')
            ElevatedButton(
             onPressed: () => _updateLeaveRequestStatus(request, 'rejected'),
             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
             child: Text('Reject'),
            ),
          ],
         ),
        ],
       ),
      ),
     );
    },
   );
  }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text(employee.name),
      actions: [
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => widget.onEditPressed(),
        ),
        // IconButton(
        //   icon: Icon(Icons.delete),
        //   onPressed: () {
        //     widget.onDeleteEmployee();
        //   },
        // ),
      ],
    ),
    body: IndexedStack(
     index: _selectedIndex,
     children: [
      _buildProfileView(),
      _buildPayrollView(),
      _buildTaskListView(),
      _buildLeaveView(),
     ],
    ),
    bottomNavigationBar: BottomNavigationBar(
     items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
       icon: Icon(Icons.person),
       label: 'Profile',
      ),
      BottomNavigationBarItem(
       icon: Icon(Icons.attach_money),
       label: 'Payroll',
      ),
      BottomNavigationBarItem(
       icon: Icon(Icons.task),
       label: 'Tasks',
      ),
      BottomNavigationBarItem(
       icon: Icon(Icons.calendar_today),
       label: 'Leave',
      ),
     ],
     currentIndex: _selectedIndex,
     selectedItemColor: Colors.amber[800],
     unselectedItemColor: Colors.grey,
     onTap: (int index) {
      setState(() {
       _selectedIndex = index;
      });
     },
    ),
    floatingActionButton: _selectedIndex == 2
      ? FloatingActionButton(
       onPressed: () => _assignNewTask(context),
       child: Icon(Icons.add),
      )
      : null,
   );
  }
 }
 

 class TaskAssignmentScreen extends StatefulWidget {
  @override
  _TaskAssignmentScreenState createState() => _TaskAssignmentScreenState();
 }
 

 class _TaskAssignmentScreenState extends State<TaskAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime dueDate = DateTime.now().add(Duration(days: 7));
 

  Future<void> _selectDate(BuildContext context) async {
   final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: dueDate,
    firstDate: DateTime.now(),
    lastDate: DateTime(2101));
   if (picked != null && picked != dueDate)
    setState(() {
     dueDate = picked;
    });
  }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
     title: Text('Assign New Task'),
    ),
    body: Padding(
     padding: const EdgeInsets.all(16.0),
     child: Form(
      key: _formKey,
      child: ListView(
       children: <Widget>[
        TextFormField(
         controller: titleController,
         decoration: InputDecoration(labelText: 'Task Title'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter a task title.';
          }
          return null;
         },
        ),
        TextFormField(
         controller: descriptionController,
         decoration: InputDecoration(labelText: 'Task Description'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter a task description.';
          }
          return null;
         },
        ),
        ListTile(
         title: Text("Due Date: ${dueDate.toLocal()}".split(' ')[0]),
         trailing: Icon(Icons.calendar_today),
         onTap: () => _selectDate(context),
        ),
        SizedBox(height: 20),
        ElevatedButton(
         onPressed: () {
          if (_formKey.currentState!.validate()) {
           final newTask = Task(
            title: titleController.text,
            description: descriptionController.text,
            dueDate: dueDate,
           );
           Navigator.pop(context, newTask);
          }
         },
         child: Text('Assign Task'),
        ),
       ],
      ),
     ),
    ),
   );
  }
 

  @override
  void dispose() {
   titleController.dispose();
   descriptionController.dispose();
   super.dispose();
  }
 }
 

 class EmployeeEditScreen extends StatefulWidget {
  final Employee? employee;
  final bool isNew;
  final Function()? onDelete;
 

  EmployeeEditScreen({Key? key, required this.employee, this.isNew = false, this.onDelete})
   : super(key: key);
 

  @override
  _EmployeeEditScreenState createState() => _EmployeeEditScreenState();
 }
 

 class _EmployeeEditScreenState extends State<EmployeeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController roleController;
  late TextEditingController profilePicController;
  late TextEditingController emailController;
  late TextEditingController departmentController;
  late TextEditingController aboutController;
 

  @override
  void initState() {
   super.initState();
   nameController = TextEditingController(text: widget.employee?.name ?? '');
   roleController = TextEditingController(text: widget.employee?.role ?? '');
   profilePicController =
     TextEditingController(text: widget.employee?.profilePic ?? '');
   emailController = TextEditingController(text: widget.employee?.email ?? '');
   departmentController =
     TextEditingController(text: widget.employee?.department ?? '');
   aboutController = TextEditingController(text: widget.employee?.about ?? '');
  }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
     title: Text(widget.isNew ? 'Add Employee' : 'Edit Employee'),
    ),
    body: Padding(
     padding: const EdgeInsets.all(16.0),
     child: Form(
      key: _formKey,
      child: ListView(
       children: [
        TextFormField(
         controller: nameController,
         decoration: InputDecoration(labelText: 'Name'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter a name.';
          }
          return null;
         },
        ),
        TextFormField(
         controller: roleController,
         decoration: InputDecoration(labelText: 'Role'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter a role.';
          }
          return null;
         },
        ),
        TextFormField(
         controller: profilePicController,
         decoration: InputDecoration(labelText: 'Profile Picture URL'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter a profile picture URL.';
          }
          if (!value.startsWith('http') && !value.startsWith('https')) {
           return 'Please enter a valid URL.';
          }
          return null;
         },
        ),
        TextFormField(
         controller: emailController,
         decoration: InputDecoration(labelText: 'Email'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter an email.';
          }
          if (!value.contains('@')) {
           return 'Please enter a valid email.';
          }
          return null;
         },
        ),
        TextFormField(
         controller: departmentController,
         decoration: InputDecoration(labelText: 'Department'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter a department.';
          }
          return null;
         },
        ),
        TextFormField(
         controller: aboutController,
         decoration: InputDecoration(labelText: 'About'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter some information about the employee.';
          }
          return null;
         },
        ),
        SizedBox(height: 20),
        ElevatedButton(
         onPressed: () {
          if (_formKey.currentState!.validate()) {
           final newEmployee = Employee(
            name: nameController.text,
            role: roleController.text,
            profilePic: profilePicController.text,
            email: emailController.text,
            department: departmentController.text,
            about: aboutController.text,
            tasks: widget.employee?.tasks ?? [],
            leaveRequests: widget.employee?.leaveRequests ?? [],
           );
           Navigator.pop(context, newEmployee);
          }
         },
         child: Text('Save'),
        ),
        if (!widget.isNew)
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Delete"),
                        content: Text(
                            "Are you sure you want to delete ${widget.employee!.name}?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text("Delete",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                              if (widget.onDelete != null) {
                                widget.onDelete!(); // Call the delete function
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Delete Employee',
                    style: TextStyle(color: Colors.white)),
              ),
        ],
      ),
     ),
    ),
   );
  }
 

  @override
  void dispose() {
   nameController.dispose();
   roleController.dispose();
   profilePicController.dispose();
   emailController.dispose();
   departmentController.dispose();
   aboutController.dispose();
   super.dispose();
  }
 }
 

 class TaskDetailScreen extends StatefulWidget {
  final Task task;
 

  TaskDetailScreen({required this.task});
 

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
 }
 

 class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime dueDate;
 

  @override
  void initState() {
   super.initState();
   titleController = TextEditingController(text: widget.task.title);
   descriptionController = TextEditingController(text: widget.task.description);
   dueDate = widget.task.dueDate;
  }
 

  Future<void> _selectDate(BuildContext context) async {
   final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: dueDate,
    firstDate: DateTime.now(),
    lastDate: DateTime(2101));
   if (picked != null && picked != dueDate)
    setState(() {
     dueDate = picked;
    });
  }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
     title: Text('Task Details'),
    ),
    body: Padding(
     padding: const EdgeInsets.all(16.0),
     child: Form(
      key: _formKey,
      child: ListView(
       children: <Widget>[
        TextFormField(
         controller: titleController,
         decoration: InputDecoration(labelText: 'Task Title'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter a task title.';
          }
          return null;
         },
        ),
        TextFormField(
         controller: descriptionController,
         decoration: InputDecoration(labelText: 'Task Description'),
         validator: (value) {
          if (value == null || value.isEmpty) {
           return 'Please enter a task description.';
          }
          return null;
         },
        ),
        ListTile(
         title: Text("Due Date: ${dueDate.toLocal()}".split(' ')[0]),
         trailing: Icon(Icons.calendar_today),
         onTap: () => _selectDate(context),
        ),
        SizedBox(height: 20),
        ElevatedButton(
         onPressed: () {
          if (_formKey.currentState!.validate()) {
           final updatedTask = Task(
            title: titleController.text,
            description: descriptionController.text,
            dueDate: dueDate,
            isCompleted: widget.task.isCompleted, // Keep the original completion status
           );
           Navigator.pop(context, updatedTask);
          }
         },
         child: Text('Update Task'),
        ),
       ],
      ),
     ),
    ),
   );
  }
 

  @override
  void dispose() {
   titleController.dispose();
   descriptionController.dispose();
   super.dispose();
  }
 }
