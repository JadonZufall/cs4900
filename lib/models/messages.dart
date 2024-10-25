import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> sendPrivateMessage(String to, String from, String message) async {
  // to and from are the uids from both users.
  // Append message to both arrays?
  db.collection("Messages").doc(to);
  db.collection("Messages").doc(from);

  // Need some method of generating uids for the messages
}

Future<void> readPrivateMessages(String to, String from) async {
  // Should return a list of privates messages with the local user being the from user?

}


class MessageInformation {
  String uid;



  MessageInformation(this.uid) {

  }
}