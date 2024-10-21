import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';


class MyProfileScreen extends StatefulWidget {
    const MyProfileScreen({super.key});

    @override
    MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  late UserInformation userInformation = UserInformation(FirebaseAuth.instance.currentUser!.uid);


  void _settingsButton() {
    navigatorKey.currentState?.pushNamed(RouteNames.myProfileSettingsRoute);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle usernameTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    TextStyle bioTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    Center loadingIndicator = const Center(child: CircularProgressIndicator());

    FutureBuilder<String> usernameField = FutureBuilder<String>(
        future: userInformation.getUsername(),
        builder: (context, snapshot) {
          log("Future data = ${snapshot.data}");
          log("${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.done) {
            return Text("${snapshot.data}", style: usernameTextStyle);
          }
          else { return loadingIndicator; }
    });
    FutureBuilder<String> bioField = FutureBuilder<String>(
        future: userInformation.getBio(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text("${snapshot.data}", style: bioTextStyle);
          }
          else { return loadingIndicator; }
        }
    );
    FutureBuilder<String> profilePictureField = FutureBuilder<String>(
      future: userInformation.getProfilePicture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.network("${snapshot.data}");
        }
        else { return loadingIndicator; }
      }
    );

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Column(
        children: [
          usernameField,
          bioField,
          profilePictureField,
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _settingsButton, child: const Icon(Icons.settings)),
    );
  }
}