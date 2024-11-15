import 'dart:developer';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/util/app_colors.dart';
import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';

class NotificationModel {
  static void sendNotification(String? senderUID, String? recipientUID, String? type, String? message) async {
    // Check if the recipient has ever had a notification document created for them
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("Notifications").doc(recipientUID!).get();
    if (!snapshot.exists) {
      await FirebaseFirestore.instance.collection("Notifications").doc(recipientUID).set({
        "ActiveNotifications": [
        ],
        "InactiveNotifications": []
      });
    }

    snapshot = await FirebaseFirestore.instance.collection("Notifications").doc(recipientUID).get();
    List<dynamic> activeNotifications = snapshot.get("ActiveNotifications");
    List<dynamic> inactiveNotifications = snapshot.get("InactiveNotifications");

    var notification = {
      "notificationId": activeNotifications.length.toString() + "_" + inactiveNotifications.length.toString(),
      "type": type,
      "user": senderUID,
      "message": message
    };

    await FirebaseFirestore.instance.collection("Notifications").doc(recipientUID).update({
      "ActiveNotifications": FieldValue.arrayUnion([notification])
    });
  }
}