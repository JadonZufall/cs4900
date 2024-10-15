import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class UserModel {
  /* Represents a single user instance.
  */
  static const String collectionName = "Users";

  static Future<DocumentSnapshot<Object?>> get(String uid) async {
    CollectionReference ref = db.collection(collectionName);
    DocumentSnapshot<Object?> res = await ref.doc(uid).get();
    return res;
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

  static void purge(String uid) {
    // Removes all content relating to the user.
  }
}

class PostModel {
  /* Represents a single upload.
   */
  static void create(String id) {

  }

  static void delete(String id) {

  }

  static void purge(String id) {

  }

}

class CommentModel {
  /* Represents a comment on a post.
   */
  static void create(String id) {

  }

  static void delete(String id) {

  }

  static void purge(String id) {

  }
}

class ConversationModel {
  /* Represents a conversation between two users.
   */

  static void create(String id) {

  }

  static void delete(String id) {

  }

  static void purge(String id) {

  }
}
