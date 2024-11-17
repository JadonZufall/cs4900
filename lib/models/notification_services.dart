import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/util/app_colors.dart';
import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    log(token!);
    return token!;
  }

  void setDeviceToken(String token) async {
    User? user = await FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance.collection("Users").doc(user!.uid).set({
      "device_token": token
    },SetOptions(merge: true));
  }

  void isRefreshToken() async {
    setDeviceToken(await getDeviceToken());

    messaging.onTokenRefresh.listen((event) async {
      log("Device token refreshed");
      setDeviceToken(await getDeviceToken());
    });
  }

  void requestNotificationPermissions() async {
    if (Platform.isIOS) {
      await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
      );
    }

    NotificationSettings notifcationSettings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );

    if (notifcationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      log('user has granted permissions');
    }
    else if (notifcationSettings.authorizationStatus == AuthorizationStatus.provisional) {
      log('user has granted provisional permissions');
    }
    else {
      log('user has denied permissions');
    }
  }

  Future foregroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      log(notification!.body.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
          content: const Text (
            'hello',
            style: TextStyle(fontSize: 16)
          ),
          duration: const Duration(seconds: 4),
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 200,
            left: 10,
            right: 10
          )
        ),
      );
    });
  }
}