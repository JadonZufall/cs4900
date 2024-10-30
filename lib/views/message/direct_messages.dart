import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({super.key});

  @override
  DirectMessagesScreenState createState() => DirectMessagesScreenState();
}

class DirectMessagesScreenState extends State<DirectMessagesScreen> {
  // Dummy data for testing the UI
  final List<Map<String, String>> dummyConversations = [
    {
      'username': 'user1',
      'lastMessage': 'Hey, how are you?',
    },
    {
      'username': 'user2',
      'lastMessage': 'Looking forward to our meeting!',
    },
    {
      'username': 'user3',
      'lastMessage': 'Can you send the files?',
    },
    {
      'username': 'user4',
      'lastMessage': 'Thanks for your help!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Direct Messages"),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: dummyConversations.length,
        itemBuilder: (context, index) {
          var conversation = dummyConversations[index];
          var username = conversation['username']!;
          var lastMessage = conversation['lastMessage']!;

          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/bloop.jpg'),
            ),
            title: Text(
              username,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              lastMessage,
              style: const TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
            ),
            onTap: () {
              // Handle opening conversation details in the future
            },
          );
        },
      ),
    );
  }
}
