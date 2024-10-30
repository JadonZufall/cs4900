import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/auth.dart';
import 'package:cs4900/views/signin.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  void _signout(BuildContext context) {
    log("Signout event triggered.");
    signoutOfAccountInstance();
    navigatorKey.currentState?.pushReplacementNamed("/signin");
    return;
  }

  void _homeButton() {
    navigatorKey.currentState?.pushNamed(RouteNames.feedScreenRoute);
  }

  void _searchButton() {
    log("_SearchButton");
    navigatorKey.currentState?.pushNamed(RouteNames.searchScreenRoute);
  }

  void _notificationsButton() {
    log("Unimplemented view");
  }

  void _profileButton() {
    navigatorKey.currentState?.pushNamed(RouteNames.myProfileScreenRoute);
  }

  void _uploadButton() {
    navigatorKey.currentState?.pushNamed(RouteNames.uploadTypeScreenRoute);
  }

  void _directMessageButton() {
    navigatorKey.currentState?.pushNamed(RouteNames.directMessageRoute);
  }

  @override
  Widget build(BuildContext context) {
    const Text title = Text("Home");

    // Check if the user is logged in.
    FirebaseAuth auth = FirebaseAuth.instance;
    String username;
    if (auth.currentUser?.displayName == null) {
      username = "null";
    } else {
      username = auth.currentUser!.displayName!;
    }

    if (auth.currentUser == null) {
      // Redirect the user to the sign in page.
      log("User is not authenticated, redirecting user to sign in page");
      return SignInScreen().build(context);
    } else {
      log("User is authenticated, loading home page.");
    }

    AppBar appBar = AppBar(
      title: title,
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
      foregroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
            icon: Icon(
                Icons.message,
                color: Colors.white,
            ),
            onPressed: () {
              _directMessageButton();
            },
        )
      ],
    );

    Text usernameLabel = Text(username);

    Padding body = Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _signout(context),
              child: Container(
                width: 80, // Adjust width for size
                height: 80, // Adjust height for size
                decoration: const BoxDecoration(
                  color:  Color.fromRGBO(32, 49, 68, 1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "Sign Out",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    BottomAppBar navbar = BottomAppBar(
      color: Color.fromRGBO(32, 49, 68, 1),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.home, size: 30),
            color: Colors.white,
            onPressed: _homeButton,
          ),
          const Spacer(flex: 1),
          IconButton(
            icon: const Icon(Icons.search, size: 30),
            color: Colors.white,
            onPressed: _searchButton,
          ),
          const Spacer(flex: 4),
          IconButton(
            icon: const Icon(Icons.notifications, size: 30),
            color: Colors.white,
            onPressed: _notificationsButton,
          ),
          const Spacer(flex: 1),
          IconButton(
            icon: const Icon(Icons.person, size: 30),
            color: Colors.white,
            onPressed: _profileButton,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: navbar,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
          child: const Icon(Icons.add), onPressed: _uploadButton),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
