import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseInterface {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  void create_user(String uid) async {
    DatabaseInterface.db.collection("users").add(
      Map<String, String>()
    );
  }
}

