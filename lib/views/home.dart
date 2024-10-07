import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import "package:cs4900/views/signin.dart";


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Text title = Text("Home");

    // Check if the user is logged in.

    FirebaseAuth auth = FirebaseAuth.instance;

    String username;
    if (auth.currentUser?.displayName == null) {
      username = "null";
    }
    else {
      username = auth.currentUser!.displayName!;
    }

    if (auth.currentUser == null) {
      // Redirect the user to the signin page.
      log("User is not authenticated, redirecting user to signin page");
      return SignInScreen().build(context);
    }

    AppBar appBar = AppBar(
      title: title,
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
      foregroundColor: Colors.white,
    );

    Text usernameLabel = Text(username);

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