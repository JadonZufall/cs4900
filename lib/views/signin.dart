import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/auth.dart';
import 'package:cs4900/views/signup.dart';
import 'package:cs4900/views/home.dart';

/*
  Displays error text if the login is invalid.
  Redirects to Signup page if the user presses the signup button.
  Redirects to the Users home page if the user logs in correctly.
*/

// TODO make a stateful widget?
class SignInScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static final StreamSubscription<User?> authListener =
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      log("Invalid password (maybe invalid event)");
    } else {
      log("Redirecting user to home page.");
      navigatorKey.currentState?.pushReplacementNamed("/home");
      SignInScreen.authListener.pause();
    }
    log("authListener paused");
  });
  SignInScreen({super.key});

  void _signin() {
    log("Signin button pressed");
    SignInScreen.authListener.resume();
    log("authListener resumed.");
    signinWithEmailAndPassword(
        _usernameController.text.trim(), _passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Username field.
            TextField(
              autocorrect: false,
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color.fromRGBO(32, 49, 68, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10.0),

            // Password Field
            TextField(
              autocorrect: false,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color.fromRGBO(32, 49, 68, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
            ),

            const SizedBox(height: 10.0),

            // Sign In button.
            ElevatedButton(
                onPressed: _signin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                )),

            const SizedBox(height: 10.0),

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up.",
                  style: TextStyle(
                    color: Color.fromRGBO(90, 104, 235, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
