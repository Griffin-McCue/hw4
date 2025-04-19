import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final roleController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    setState(() {
      firstNameController.text = doc['firstName'];
      lastNameController.text = doc['lastName'];
      roleController.text = doc['role'];
      isLoading = false;
    });
  }

  Future<void> updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'role': roleController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated.")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(controller: firstNameController, decoration: InputDecoration(labelText: "Given Name")),
                  TextField(controller: lastNameController, decoration: InputDecoration(labelText: "Surname")),
                  TextField(controller: roleController, decoration: InputDecoration(labelText: "Role")),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateProfile,
                    child: Text("Update Profile"),
                  )
                ],
              ),
            ),
    );
  }
}