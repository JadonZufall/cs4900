import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Text title = Text("Home");

    // Check if the user is logged in.
    String? username;
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      //
      log("User is not authenticated, redirecting user to signin page");
      Navigator.of(context).pushNamed("signin");
    }
    else {
      username = auth.currentUser?.displayName;
    }

    AppBar appBar = AppBar(
      title: title,
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
      foregroundColor: Colors.white,
    );

    Padding body = const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          // All requires elements in the body should be contained here.

        ],
      ),
    );


    return Scaffold(appBar: appBar, body: body);
  }
}