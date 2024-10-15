import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class UserModel {
  /* Represents a single user instance.
  */
  static const String collectionName = "Users";
  static const List<String> collectionFields = ["uid", "email", "username", "phone", "followers", "following"];

  static Future<DocumentSnapshot<Object?>> get(String uid) async {
    /* Retrieves the document snapshot of a specific user from their user id.
    */
    CollectionReference ref = db.collection(collectionName);
    DocumentSnapshot<Object?> res = await ref.doc(uid).get();
    return res;
  }

  static Future<void> set(String uid) async {
    throw Exception("Not Implemented Exception.");
  }

  static Future<bool> exists(String uid) async {
    DocumentSnapshot<Object?> user = await UserModel.get(uid);
    return user.exists;
  }

  static void validate(String uid, {email="", username="", phone=""}) async {
    if (await UserModel.exists(uid)) {
      log("Validated user $uid.");
      return;
    }
    else {
      // Create filler model data.
      UserModel.create(uid, email, username, phone);
    }
  }

  static void create(String uid, String email, String username, String phone) {
    final user = <String, dynamic> {
      "uid": uid,
      "email": email,
      "username": username,
      "phone": phone,
      "followers": [],
      "following": []
    };
    db.collection(UserModel.collectionName).doc(uid).set(user);
  }

  static void delete(String uid) {
    final ref = db.doc("users/$uid");
    ref.delete();
  }
}

class PostModel {
  /* Represents a single upload.
   */
  static Future<DocumentSnapshot<Object?>> get(String uid) async {
    throw Exception("Not Implemented Exception.");
  }

  static Future<bool> exists(String uid) async {
    throw Exception("Not Implemented Exception.");
  }

  static void create(String id) {
    throw Exception("Not Implemented Exception.");
  }

  static void delete(String id) {
    throw Exception("Not Implemented Exception.");
  }
}

class CommentModel {
  /* Represents a comment on a post.
   */
  static Future<DocumentSnapshot<Object?>> get(String uid) async {
    throw Exception("Not Implemented Exception.");
  }

  static Future<bool> exists(String uid) async {
    throw Exception("Not Implemented Exception.");
  }

  static void create(String id) {
    throw Exception("Not Implemented Exception.");
  }

  static void delete(String id) {
    throw Exception("Not Implemented Exception.");
  }
}

class ConversationModel {
  /* Represents a conversation between two users.
   */
  static Future<DocumentSnapshot<Object?>> get(String uid) async {
    throw Exception("Not Implemented Exception.");
  }

  static Future<bool> exists(String uid) async {
    throw Exception("Not Implemented Exception.");
  }

  static void create(String id) {
    throw Exception("Not Implemented Exception.");
  }

  static void delete(String id) {
    throw Exception("Not Implemented Exception.");
  }
}
