 import 'package:flutter/material.dart';
 

 class FlowsScreen extends StatefulWidget {
  @override
  _FlowsScreenState createState() => _FlowsScreenState();
 }
 

 class Flow {
  String name;
  String description;
  bool isEnabled;
  String trigger;
  List<String> actions;
 

  Flow({
  required this.name,
  required this.description,
  this.isEnabled = true,
  this.trigger = '',
  this.actions = const [],
  });
 }
 

 class _FlowsScreenState extends State<FlowsScreen> {
  List<Flow> flows = [
  Flow(
  name: "Auto Absence Alert",
  description: "Sends an alert when an employee is absent without notice.",
  trigger: "Absence Detected",
  actions: ["Send Email", "Update Record"],
  ),
  Flow(
  name: "Late Arrival Notification",
  description: "Notifies manager when an employee is late.",
  trigger: "Late Arrival",
  actions: ["Send Slack Message"],
  ),
  Flow(
  name: "Leave Approval Flow",
  description: "Handles leave requests and approvals.",
  trigger: "Leave Request Submitted",
  actions: ["Send Email", "Update Leave Balance"],
  ),
  ];
 

  void _addNewFlow() async {
  final newFlow = await Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => FlowEditScreen(flow: Flow(name: '', description: '')),
  ),
  );
  if (newFlow != null) {
  setState(() {
  flows.add(newFlow);
  });
  }
  }
 

  void _editFlow(int index) async {
  final updatedFlow = await Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => FlowEditScreen(flow: flows[index]),
  ),
  );
  if (updatedFlow != null) {
  setState(() {
  flows[index] = updatedFlow;
  });
  }
  }
 

  void _deleteFlow(int index) {
  setState(() {
  flows.removeAt(index);
  });
  }
 

  void _toggleFlow(int index, bool value) {
  setState(() {
  flows[index].isEnabled = value;
  });
  }
 

  void _initiateFlow(Flow flow) {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => InitiateFlowScreen(flow: flow),
  ),
  );
  }
 

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text("Flow Requests"),
  actions: [
  IconButton(
  icon: Icon(Icons.filter_list),
  onPressed: () {
  // Handle filter action
  },
  ),
  ],
  ),
  body: flows.isEmpty
  ? Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  Image.network(
  "https://placehold.co/200x150",
  width: 200,
  height: 150,
  ),
  SizedBox(height: 20),
  Text(
  "Hey! looks like you don't have any workflow requests",
  style: TextStyle(color: Colors.grey),
  ),
  ],
  ),
  )
  : ListView.builder(
  itemCount: flows.length,
  itemBuilder: (context, index) {
  final flow = flows[index];
  return Card(
  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  child: ListTile(
  title: Text(flow.name),
  subtitle: Text(flow.description),
  trailing: ElevatedButton(
  onPressed: () => _initiateFlow(flow),
  child: Text('Initiate'),
  ),
  ),
  );
  },
  ),
  floatingActionButton: FloatingActionButton(
  onPressed: _addNewFlow,
  child: Icon(Icons.add),
  backgroundColor: Colors.blue,
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  bottomNavigationBar: BottomAppBar(
  shape: CircularNotchedRectangle(),
  notchMargin: 8.0,
  child: Container(height: 50),
  ),
  );
  }
 }
 

 class FlowEditScreen extends StatefulWidget {
  final Flow flow;
 

  FlowEditScreen({required this.flow});
 

  @override
  _FlowEditScreenState createState() => _FlowEditScreenState();
 }
 

 class _FlowEditScreenState extends State<FlowEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  String? selectedTrigger;
  List<String> selectedActions = [];
 

  List<String> availableTriggers = [
  "Employee Clock-in",
  "Leave Request Submitted",
  "Absence Detected",
  ];
  List<String> availableActions = [
  "Send Email",
  "Send Slack Message",
  "Update Attendance Record",
  "Create Task",
  ];
 

  @override
  void initState() {
  super.initState();
  nameController = TextEditingController(text: widget.flow.name);
  descriptionController = TextEditingController(text: widget.flow.description);
  selectedTrigger = widget.flow.trigger.isNotEmpty ? widget.flow.trigger : null;
  selectedActions = List.from(widget.flow.actions);
  }
 

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text(widget.flow.name.isEmpty ? "Add New Flow" : "Edit Flow"),
  ),
  body: Padding(
  padding: EdgeInsets.all(16.0),
  child: Form(
  key: _formKey,
  child: ListView(
  children: [
  TextFormField(
  controller: nameController,
  decoration: InputDecoration(labelText: "Flow Name"),
  validator: (value) {
  if (value == null || value.isEmpty) {
  return "Please enter a flow name.";
  }
  return null;
  },
  ),
  TextFormField(
  controller: descriptionController,
  decoration: InputDecoration(labelText: "Flow Description"),
  validator: (value) {
  if (value == null || value.isEmpty) {
  return "Please enter a flow description.";
  }
  return null;
  },
  ),
  DropdownButtonFormField<String>(
  decoration: InputDecoration(labelText: "Trigger"),
  value: selectedTrigger,
  onChanged: (String? newValue) {
  setState(() {
  selectedTrigger = newValue;
  });
  },
  items: availableTriggers.map((String trigger) {
  return DropdownMenuItem<String>(
  value: trigger,
  child: Text(trigger),
  );
  }).toList(),
  ),
  Text("Actions:", style: TextStyle(fontWeight: FontWeight.bold)),
  Column(
  children: availableActions.map((String action) {
  return CheckboxListTile(
  title: Text(action),
  value: selectedActions.contains(action),
  onChanged: (bool? value) {
  setState(() {
  if (value == true) {
  selectedActions.add(action);
  } else {
  selectedActions.remove(action);
  }
  });
  },
  );
  }).toList(),
  ),
  SizedBox(height: 20),
  ElevatedButton(
  onPressed: () {
  if (_formKey.currentState!.validate()) {
  final updatedFlow = Flow(
  name: nameController.text,
  description: descriptionController.text,
  isEnabled: widget.flow.isEnabled,
  trigger: selectedTrigger ?? '',
  actions: selectedActions,
  );
  Navigator.pop(context, updatedFlow);
  }
  },
  child: Text("Save"),
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
  descriptionController.dispose();
  super.dispose();
  }
 }
 

 class InitiateFlowScreen extends StatelessWidget {
  final Flow flow;
 

  InitiateFlowScreen({required this.flow});
 

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text("Initiate ${flow.name}"),
  ),
  body: Center(
  child: Text("Configuration options for initiating ${flow.name} will be displayed here."),
  ),
  );
  }
 }
