import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/auth.dart';
import 'package:cs4900/views/signin.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  // Placeholder data for notifications
  final List<Map<String, String>> notifications = [
    {
      'type': 'like',
      'user': 'user1',
      'message': 'liked your post',
      'profilePic': 'assets/images/bloop.jpg'
    },
    {
      'type': 'comment',
      'user': 'user2',
      'message': 'commented: "Great photo!"',
      'profilePic': 'assets/images/bloop.jpg'
    },
    {
      'type': 'follow',
      'user': 'user3',
      'message': 'started following you',
      'profilePic': 'assets/images/bloop.jpg'
    },
  ];

  // Helper function to get the right icon based on notification type
  IconData getIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.message;
      case 'follow':
        return Icons.person;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () {
              // Display a SnackBar as a placeholder for a push notification
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                  content: Text(
                    '${notification['user']} ${notification['message']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(32, 49, 68, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Profile picture and icon
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(notification['profilePic']!),
                          radius: 20,
                        ),
                        Icon(
                          getIcon(notification['type']!),
                          color: Color.fromRGBO(150, 150, 150, 1),
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    // Notification text
                    Expanded(
                      child: Text(
                        '${notification['user']} ${notification['message']}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
