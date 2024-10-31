import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';

class MyProfileSettingsScreen extends StatefulWidget {
  const MyProfileSettingsScreen({super.key});

  @override
  MyProfileSettingsState createState() => MyProfileSettingsState();
}

class MyProfileSettingsState extends State<MyProfileSettingsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  late UserInformation userInformation =
      UserInformation(FirebaseAuth.instance.currentUser!.uid);

  void _saveUsernameButton() async {
    String value = _usernameController.text;
    await userInformation.setUsername(value);
    _usernameController.clear();
    navigatorKey.currentState?.pop();
  }

  void _saveBioButton() async {
    String value = _bioController.text;
    await userInformation.setBio(value);
    _bioController.clear();
    navigatorKey.currentState?.pop();
  }

  void _saveProfilePictureButton() {
    navigatorKey.currentState?.pushNamed(RouteNames.profilePictureScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    InputDecoration usernameInputDecoration = InputDecoration(
      labelText: "Username",
      labelStyle: const TextStyle(color: Color.fromRGBO(148, 173, 199, 1)),
      filled: true,
      fillColor: const Color.fromRGBO(32, 49, 68, 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
    );

    Container changeUsernameField = Container(
      child: Column(
        children: [
          Text("Change Username", style: labelTextStyle),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _usernameController,
              decoration: usernameInputDecoration,
              style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              )
            ),
          ),
        ],
      ),
    );

    InputDecoration bioInputDecoration = InputDecoration(
      labelText: "Bio",
      labelStyle: const TextStyle(color: Color.fromRGBO(148, 173, 199, 1)),
      filled: true,
      fillColor: const Color.fromRGBO(32, 49, 68, 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
    );

    Container changeBioField = Container(
      child: Column(
        children: [
          Text("Change Bio", style: labelTextStyle),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _bioController,
              decoration: bioInputDecoration,
              style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
              )
            ),
          ),
        ],
      ),
    );

    Column body = Column(children: [
      changeUsernameField,
      ElevatedButton(
        onPressed: _saveUsernameButton,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(32, 49, 68, 1)),
        child:
            const Text("Save Username", style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(height: 64.0),
      changeBioField,
      ElevatedButton(
        onPressed: _saveBioButton,
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(32, 49, 68, 1)),
        child:
            const Text("Save Bio", style: TextStyle(color: Colors.white)),
      ),
      ElevatedButton(
          onPressed: _saveProfilePictureButton,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(32, 49, 68, 1)),
          child: const Text("Update Profile Picture", style: TextStyle(color: Colors.white))
      )
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile Settings"),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: body,
    );
  }
}
