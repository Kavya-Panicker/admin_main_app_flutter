import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HelpdeskScreen(),
    theme: ThemeData(primarySwatch: Colors.blue),
  ));
}

class HelpdeskScreen extends StatefulWidget {
  @override
  _HelpdeskScreenState createState() => _HelpdeskScreenState();
}

class _HelpdeskScreenState extends State<HelpdeskScreen> {
  String? selectedCategory;
  String? selectedPriority;
  TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> tickets = []; // List of submitted tickets

  final List<String> categories = [
    "Login Issue",
    "Payment Problem",
    "App Bug",
    "Account Issue",
    "Other"
  ];
  final List<String> priorities = ["Low", "Medium", "High"];

  void submitTicket() {
    if (selectedCategory == null || selectedPriority == null || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      tickets.add({
        "id": "#${tickets.length + 1}",
        "category": selectedCategory,
        "description": descriptionController.text,
        "priority": selectedPriority,
        "status": "Open",
        "assignedAgent": "Not Assigned",
      });
    });

    descriptionController.clear();
    selectedCategory = null;
    selectedPriority = null;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ticket Submitted Successfully")));
  }

  void assignAgent(int index) {
    setState(() {
      tickets[index]["assignedAgent"] = "Agent ${index + 1}";
      tickets[index]["status"] = "In Progress";
    });
  }

  void resolveTicket(int index) {
    setState(() {
      tickets[index]["status"] = "Resolved";
    });
  }

  void escalateTicket(int index) {
    setState(() {
      tickets[index]["status"] = "Escalated";
    });
  }

  void closeTicket(int index) {
    setState(() {
      tickets[index]["status"] = "Closed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Helpdesk Support")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Submit a Ticket", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              value: selectedCategory,
              hint: Text("Select Category"),
              onChanged: (value) => setState(() => selectedCategory = value),
              items: categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(border: OutlineInputBorder()),
              value: selectedPriority,
              hint: Text("Select Priority"),
              onChanged: (value) => setState(() => selectedPriority = value),
              items: priorities.map((priority) => DropdownMenuItem(value: priority, child: Text(priority))).toList(),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Describe your issue"),
              maxLines: 3,
            ),
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: submitTicket,
                child: Text("Submit Ticket", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            Text("Tickets Dashboard", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: tickets.isEmpty
                  ? Center(child: Text("No Tickets Submitted"))
                  : ListView.builder(
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = tickets[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text("${ticket['id']} - ${ticket['category']}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Priority: ${ticket['priority']}"),
                                Text("Status: ${ticket['status']}"),
                                Text("Assigned Agent: ${ticket['assignedAgent']}"),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == "Assign Agent") assignAgent(index);
                                if (value == "Resolve") resolveTicket(index);
                                if (value == "Escalate") escalateTicket(index);
                                if (value == "Close") closeTicket(index);
                              },
                              itemBuilder: (context) => [
                                if (ticket['status'] == "Open") PopupMenuItem(value: "Assign Agent", child: Text("Assign Agent")),
                                if (ticket['status'] == "In Progress") PopupMenuItem(value: "Resolve", child: Text("Resolve")),
                                if (ticket['status'] == "In Progress") PopupMenuItem(value: "Escalate", child: Text("Escalate")),
                                if (ticket['status'] == "Resolved") PopupMenuItem(value: "Close", child: Text("Close")),
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
    );
  }
}
