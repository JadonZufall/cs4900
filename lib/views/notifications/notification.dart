import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/util/app_colors.dart';
import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';

class NotificationItem extends StatefulWidget {
  final String? user;
  final String? message;
  final String? type;

  const NotificationItem({super.key, required this.user, required this.type, required this.message});

  @override
  NotificationItemState createState() => NotificationItemState();
}

class NotificationItemState extends State<NotificationItem> {
  Future<Map<String, dynamic>> getUserInformation() async {
    log(widget.user!);
    UserInformation senderInformation = await UserInformation(widget.user!);

    return {
      'Username': await senderInformation.getUsername(),
      'PFP': await senderInformation.getProfilePicture()
    };
  }

  IconData getIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.message;
      case 'follow':
        return Icons.person;
      case 'message':
        return Icons.message_rounded;
      default:
        return Icons.notifications;
    }
  }

  String formatMessage(String? message) {
    switch (widget.type) {
      case "message":
        return "said: " + message!;
      case "like":
          return "Liked your post";
      case "follow":
        return "Began following you";
      case "comment":
        return "commented: " + message!;
      default:
        return "";
    }
  }

  Widget getFutureBuilder() {
    Widget loadingState = const SizedBox(width: 375, height: 429, child: Center(child: CircularProgressIndicator()));

    return FutureBuilder<Map<String, dynamic>>(
      future: getUserInformation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState  == ConnectionState.done){
          if (snapshot.data == null) {
            log("Error snapshot data is null");
            return loadingState;
          }
          return buildNotification(snapshot.data!);
        }
        else {
          return loadingState;
        }
      },
    );
  }

  Widget buildNotification(Map<String, dynamic> userInfo) {
    return Container(
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
                    backgroundImage: NetworkImage(userInfo['PFP']),
                    radius: 20,
                  ),
                  Icon(
                    getIcon(widget.type!),
                    color: Color.fromRGBO(150, 150, 150, 1),
                    size: 20,
                  )
                ],
              ),
              SizedBox(width: 10),

              Expanded(
                  child: Text(
                    '${userInfo['Username']} ${formatMessage(widget.message)}',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return getFutureBuilder();
  }
}
