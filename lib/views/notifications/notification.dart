import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/util/app_colors.dart';
import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';

class Notfication extends StatelessWidget {
  final String? user;
  final String? message;
  final String? senderPfp;
  final String? type;

  const Notfication({super.key, required this.user, required this.type, required this.message, required this.senderPfp});

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

  @override
  Widget build(BuildContext context) {
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
                backgroundImage: NetworkImage(senderPfp!),
                radius: 20,
              ),
              Icon(
                getIcon(type!),
                color: Color.fromRGBO(150, 150, 150, 1),
                size: 20,
              )
            ],
          ),
          SizedBox(width: 10),

          Expanded(
            child: Text(
              '${user} ${message}',
              style: TextStyle(fontSize: 16, color: Colors.white),
            )
          )
        ]
      )
    );
  }
}
