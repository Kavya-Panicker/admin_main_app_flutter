 import 'package:flutter/material.dart';
 import 'dart:io';
 import 'package:shared_preferences/shared_preferences.dart';
 import 'package:image_picker/image_picker.dart';
 import 'complete_profile.dart';
 

 class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
 }
 

 class _ProfileScreenState extends State<ProfileScreen> {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;
  String? age;
  String? birthDate;
  String? profileImagePath;
  bool isProfileCompleted = false;
  final picker = ImagePicker();
 

  @override
  void initState() {
   super.initState();
   _loadProfileData();
  }
 

  // Load profile data from SharedPreferences
  _loadProfileData() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {
    firstName = prefs.getString('firstName') ?? '';
    lastName = prefs.getString('lastName') ?? '';
    phoneNumber = prefs.getString('phoneNumber') ?? '';
    address = prefs.getString('address') ?? '';
    age = prefs.getString('age') ?? '';
    birthDate = prefs.getString('birthDate') ?? '';
    profileImagePath = prefs.getString('profileImagePath') ?? '';
    isProfileCompleted = prefs.getBool('isProfileCompleted') ?? false;
   });
  }
 

  void _navigateToCompleteProfile() async {
   final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CompleteProfileScreen()),
   );
 

   if (result != null && result is Map<String, dynamic>) {
    setState(() {
     firstName = result["First Name"];
     lastName = result["Last Name"];
     phoneNumber = result["Phone Number"];
     address = result["Address"];
     age = result["Age"];
     birthDate = result["Date of Birth"];
     profileImagePath = result["Profile Image"];
     isProfileCompleted = true;
    });
 

    // Save profile data to SharedPreferences
    _saveProfileData();
   }
  }
 

  // Save profile data to SharedPreferences
  _saveProfileData() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString('firstName', firstName ?? '');
   prefs.setString('lastName', lastName ?? '');
   prefs.setString('phoneNumber', phoneNumber ?? '');
   prefs.setString('address', address ?? '');
   prefs.setString('age', age ?? '');
   prefs.setString('birthDate', birthDate ?? '');
   prefs.setString('profileImagePath', profileImagePath ?? '');
   prefs.setBool('isProfileCompleted', isProfileCompleted);
  }
 

  Future _pickImage() async {
   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
 

   setState(() {
    if (pickedFile != null) {
     profileImagePath = pickedFile.path;
     isProfileCompleted = true;
     _saveProfileData();
    }
   });
  }
 

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
     title: Text("Profile"),
     actions: [
      if (isProfileCompleted)
       IconButton(
        icon: Icon(Icons.edit),
        onPressed: _navigateToCompleteProfile,
       ),
     ],
    ),
    body: Padding(
     padding: EdgeInsets.all(16.0),
     child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       Stack(
        children: [
         CircleAvatar(
          radius: 50,
          backgroundImage: profileImagePath != null
            ? FileImage(File(profileImagePath!)) as ImageProvider<Object>?
            : AssetImage('assets/default_profile.png') as ImageProvider<Object>?, // Replace with your default asset
          backgroundColor: Colors.grey,
         ),
         Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
           onTap: _pickImage,
           child: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
             color: Colors.blue,
             shape: BoxShape.circle,
            ),
            child: Icon(
             Icons.camera_alt,
             size: 20,
             color: Colors.white,
            ),
           ),
          ),
         ),
        ],
       ),
       SizedBox(height: 20),
       if (!isProfileCompleted)
        Center(
         child: ElevatedButton(
          onPressed: _navigateToCompleteProfile,
          child: Text("Complete Profile"),
         ),
        )
       else ...[
        buildSectionTitle("Personal Details"),
        buildProfileDetail("First Name", firstName),
        buildProfileDetail("Last Name", lastName),
        buildProfileDetail("Phone Number", phoneNumber),
        buildProfileDetail("Address", address),
        buildProfileDetail("Age", age),
        buildProfileDetail("Date of Birth", birthDate),
       ],
      ],
     ),
    ),
   );
  }
 

  Widget buildSectionTitle(String title) {
   return Padding(
    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
    child: Text(
     title,
     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
   );
  }
 

  Widget buildProfileDetail(String title, String? value) {
   return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.0),
    child: ListTile(
     title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
     subtitle: Text(value ?? "-"),
     tileColor: Colors.grey[200],
    ),
   );
  }
 }
