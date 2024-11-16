import 'dart:developer';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs4900/Util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs4900/views/notifications/notification.dart';
import 'package:cloud_functions/cloud_functions.dart';


import 'package:cs4900/main.dart';
import 'package:cs4900/auth.dart';
import 'package:cs4900/views/signin.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  User? user = FirebaseAuth.instance.currentUser!;
  var _future;

  @override
  void initState() {
    super.initState();
    _future = getNotifications();
  }

  Widget getNotification(List<List<dynamic>> notificationList,int index) {


    int numActiveInbox = notificationList[0].length;
    int numInactiveInbox = notificationList[1].length;

    var notification;

    if (index < numActiveInbox) {
      notification = notificationList[0][index];
    }
    else {
      notification = notificationList[1][index - numActiveInbox];
    }

    return NotificationItem(user: notification['user'], type: notification['type'], message: notification['message']);
  }

  Future<List<List<dynamic>>> getNotifications() async {
    user = await FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("Notifications").doc(user!.uid).get();

    if(!snap.exists) {
      await FirebaseFirestore.instance.collection("Notifications").doc(user!.uid).set({
        "ActiveNotifications": [],
        "InactiveNotifications": []
      });
      snap = await FirebaseFirestore.instance.collection("Notifications").doc(user!.uid).get();
    }

    List<dynamic> activeNotifications = await snap.get("ActiveNotifications");
    List<dynamic> inactiveNotifications = await snap.get("InactiveNotifications");

    return [activeNotifications, inactiveNotifications];
  }

  Widget notificationScreenStreamBuilder(List<List<dynamic>> notifications) {
    Widget loadingState = const Center(child: CircularProgressIndicator());

    return StreamBuilder<DocumentSnapshot> (
      stream: FirebaseFirestore.instance.collection("Notifications").doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log("Error in notification stream builder");
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return buildNotificationScreen(notifications);
        }
        notifications[0] = snapshot.data!.get("ActiveNotifications");
        notifications[1] = snapshot.data!.get("InactiveNotifications");
        return buildNotificationScreen(notifications);
      }
    );
  }

  Widget buildNotificationScreen(List<List<dynamic>> notifications) {
    return CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return getNotification(notifications, index);
            }, childCount: notifications[0].length + notifications[1].length),
          )
        ],
      );
  }

  /*@override
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
  }*/

  Widget notificationScreenFutureBuilder() {
    Widget loadingState = const Center(
      child: CircularProgressIndicator(),
    );

    return FutureBuilder<List<List<dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              log("Error: snapshot data is null");
              return loadingState;
            }
            return notificationScreenStreamBuilder(snapshot.data!);
          }
          else {
            return loadingState;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Container(
        child: notificationScreenFutureBuilder(),
      )
    );
  }
}
