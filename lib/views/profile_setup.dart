
import 'dart:developer';
import 'package:flutter/material.dart';


import 'package:firebase_auth/firebase_auth.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/auth.dart';
import 'package:cs4900/views/signin.dart';

class ProfileSetupScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  ProfileSetupScreen({super.key});

  void _signout(BuildContext context) {
    log("Signout event triggered.");
    signoutOfAccountInstance();
    navigatorKey.currentState?.pushReplacementNamed("/signin");
    return;
  }

  void _setUsername(BuildContext context) async {
    log("Set username trigger");
    await setLocalUsername(_usernameController.text);
    navigatorKey.currentState?.pushReplacementNamed(RouteNames.myProfileScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    Padding body = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // All requires elements in the body should be contained here.

          TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: const TextStyle(color:  Color.fromRGBO(148, 173, 199, 1)),
                filled: true,
                fillColor: const Color.fromRGBO(255, 255, 255, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              )
          ),
          ElevatedButton(onPressed: () {_setUsername(context);}, child: const Text("Set Username")),
          ElevatedButton(onPressed: () {_signout(context);}, child: const Text("Sign Out")),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: body,
    );
  }
}