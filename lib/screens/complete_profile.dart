 import 'package:flutter/material.dart';
 import 'package:image_picker/image_picker.dart';
 import 'dart:io';
 

 class CompleteProfileScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? address;
  final String? age;
  final String? birthDate;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String? education;
  final String? university;
  final String? profileImagePath;
 

  CompleteProfileScreen({
   this.firstName,
   this.lastName,
   this.phoneNumber,
   this.address,
   this.age,
   this.birthDate,
   this.bankName,
   this.accountNumber,
   this.ifscCode,
   this.education,
   this.university,
   this.profileImagePath,
  });
 

  @override
  _CompleteProfileScreenState createState() => _CompleteProfileScreenState();
 }
 

 class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController universityController = TextEditingController();
  File? _profileImage;
 

  bool _personalDetailsExpanded = false;
  bool _bankDetailsExpanded = false;
  bool _educationDetailsExpanded = false;
 

  @override
  void initState() {
   super.initState();
   // Initialize the text controllers with the passed data
   firstNameController.text = widget.firstName ?? '';
   lastNameController.text = widget.lastName ?? '';
   phoneNumberController.text = widget.phoneNumber ?? '';
   addressController.text = widget.address ?? '';
   ageController.text = widget.age ?? '';
   birthDateController.text = widget.birthDate ?? '';
   bankNameController.text = widget.bankName ?? '';
   accountNumberController.text = widget.accountNumber ?? '';
   ifscCodeController.text = widget.ifscCode ?? '';
   educationController.text = widget.education ?? '';
   universityController.text = widget.university ?? '';
 

   if (widget.profileImagePath != null) {
    _profileImage = File(widget.profileImagePath!);
   }
  }
 

  Future<void> _pickImage() async {
   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
   if (pickedFile != null) {
    setState(() {
     _profileImage = File(pickedFile.path);
    });
   }
  }
 

  void _saveProfile() {
   Map<String, dynamic> profileData = {
    "First Name": firstNameController.text,
    "Last Name": lastNameController.text,
    "Phone Number": phoneNumberController.text,
    "Address": addressController.text,
    "Age": ageController.text,
    "Date of Birth": birthDateController.text,
    "Profile Image": _profileImage?.path,
    "Bank Name": bankNameController.text,
    "Account Number": accountNumberController.text,
    "IFSC Code": ifscCodeController.text,
    "Education": educationController.text,
    "University": universityController.text,
   };
 

   Navigator.pop(context, profileData);
  }
 

  Widget buildTextField(String label, TextEditingController controller) {
   return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: TextField(
     controller: controller,
     decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
     ),
    ),
   );
  }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(title: Text("Complete Profile")),
    body: SingleChildScrollView(
     padding: EdgeInsets.all(16.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Center(
        child: GestureDetector(
         onTap: _pickImage,
         child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
          child: _profileImage == null
            ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
            : null,
         ),
        ),
       ),
       SizedBox(height: 20),
       ExpansionTile(
        title: Text(
         "Personal Details",
         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: _personalDetailsExpanded,
        onExpansionChanged: (bool expanded) {
         setState(() {
          _personalDetailsExpanded = expanded;
         });
        },
        children: [
         buildTextField("First Name", firstNameController),
         buildTextField("Last Name", lastNameController),
         buildTextField("Phone Number", phoneNumberController),
         buildTextField("Address", addressController),
         buildTextField("Age", ageController),
         buildTextField("Date of Birth", birthDateController),
        ],
       ),
       ExpansionTile(
        title: Text(
         "Bank Details",
         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: _bankDetailsExpanded,
        onExpansionChanged: (bool expanded) {
         setState(() {
          _bankDetailsExpanded = expanded;
         });
        },
        children: [
         buildTextField("Bank Name", bankNameController),
         buildTextField("Account Number", accountNumberController),
         buildTextField("IFSC Code", ifscCodeController),
        ],
       ),
       ExpansionTile(
        title: Text(
         "Education Details",
         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: _educationDetailsExpanded,
        onExpansionChanged: (bool expanded) {
         setState(() {
          _educationDetailsExpanded = expanded;
         });
        },
        children: [
         buildTextField("Education", educationController),
         buildTextField("University", universityController),
        ],
       ),
       SizedBox(height: 20),
       Center(
        child: ElevatedButton(
         onPressed: _saveProfile,
         child: Text("Save"),
        ),
       ),
      ],
     ),
    ),
   );
  }
 }
