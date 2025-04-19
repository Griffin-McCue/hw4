import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DateTime? selectedDob;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists && doc['dob'] != null) {
      Timestamp dobTimestamp = doc['dob'];
      setState(() {
        selectedDob = dobTimestamp.toDate();
      });
    }

    setState(() => isLoading = false);
  }

  Future<void> updateDob(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'dob': Timestamp.fromDate(date),
    });

    setState(() => selectedDob = date);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Date of birth updated.")));
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  void pickDate() async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year - 100);
    DateTime lastDate = DateTime(now.year + 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDob ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      await updateDob(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Date of Birth: "),
                      Text(selectedDob != null
                          ? "${selectedDob!.toLocal()}".split(' ')[0]
                          : "Not set"),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: pickDate,
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.logout),
                    label: Text("Log Out"),
                    onPressed: logout,
                  ),
                ],
              ),
            ),
    );
  }
}