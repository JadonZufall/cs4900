import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class User {
  static void create(String id) {

    final user = <String, dynamic> {
      "id": id,
    };

    db.collection("Users").add(user);
  }

  static void delete(String id) {
    final ref = db.doc("users/$id");
    ref.delete();
  }
}

class Post {
  static void create(String id) {

  }

  static void delete(String id) {

  }

}

class Comment {
  static void create(String id) {

  }

  static void delete(String id) {

  }
}
