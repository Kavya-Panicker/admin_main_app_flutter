import 'package:flutter/material.dart';

class AddEditJobScreen extends StatefulWidget {
  final Map<String, String>? job;

  AddEditJobScreen({this.job});

  @override
  _AddEditJobScreenState createState() => _AddEditJobScreenState();
}

class _AddEditJobScreenState extends State<AddEditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      titleController.text = widget.job!["title"]!;
      companyController.text = widget.job!["company"]!;
      locationController.text = widget.job!["location"]!;
    }
  }

  void _saveJob() {
    if (_formKey.currentState!.validate()) {
      Map<String, String> job = {
        "title": titleController.text,
        "company": companyController.text,
        "location": locationController.text,
      };

      Navigator.pop(context, job);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.job == null ? "Add Job" : "Edit Job")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Job Title"),
                validator: (value) => value!.isEmpty ? "Enter job title" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: companyController,
                decoration: InputDecoration(labelText: "Company Name"),
                validator: (value) => value!.isEmpty ? "Enter company name" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(labelText: "Location"),
                validator: (value) => value!.isEmpty ? "Enter job location" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveJob,
                child: Text("Save Job"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
