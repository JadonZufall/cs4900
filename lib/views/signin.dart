import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:cs4900/auth.dart';
import 'package:cs4900/views/signup.dart';


/*
  Displays error text if the login is invalid.
  Redirects to Signup page if the user presses the signup button.
  Redirects to the Users home page if the user logs in correctly.
*/


class SignInScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignInScreen({super.key});

  void _signin() {
    log("Signin button pressed");
    signinWithEmailAndPassword(_usernameController.text, _passwordController.text);
    FirebaseAuth auth = FirebaseAuth.instance;
    String username;
    if (auth.currentUser != null) {
      log("Logged in as...");
      log(auth.currentUser!.displayName ?? "null");
    }
    else {
      log("Failed to log in");
    }
    // TODO routing.
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
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color:  Color.fromRGBO(148, 173, 199, 1)),
                filled: true,
                fillColor: const Color.fromRGBO(36, 54, 71, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              )
            ),


            // Password Field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color:  Color.fromRGBO(148, 173, 199, 1)),
                filled: true,
                fillColor: const Color.fromRGBO(36, 54, 71, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              obscureText: true,
            ),

            // Sign In button.
            ElevatedButton(onPressed: _signin, child: const Text("Sign In")),

            Material(
              color: Colors.transparent,
              child: InkWell(onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()),);
                },
                child: const Text("Don't have an account? Sign Up.",
                  style: TextStyle(
                    color: Colors.white,
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