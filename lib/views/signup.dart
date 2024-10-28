import 'dart:developer';
import 'package:cs4900/main.dart';
import 'package:flutter/material.dart';

import 'package:cs4900/auth.dart';
import 'package:cs4900/views/signin.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUpScreen({super.key});

  void _signup() {
    log("Signup button pressed");
    signupWithEmailAndPassword(
        _usernameController.text.trim(), _passwordController.text.trim());
    _usernameController.clear();
    _passwordController.clear();
    navigatorKey.currentState?.pushReplacementNamed("/signin");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            // Username field.
            TextField(
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

            ElevatedButton(
              onPressed: _signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ]),
        ));
  }
}
