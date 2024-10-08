import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class User {
  /* Represents a single user instance.
  */
  static void create(String id, String email, String username, String phone) {
    final user = <String, dynamic> {
      "id": id,
      "email": email,
      "username": username,
      "phone": phone,
      "followers": [],
      "following": []
    };

    db.collection("Users").add(user);
  }

  static void delete(String id) {
    final ref = db.doc("users/$id");
    ref.delete();
  }

  static void purge(String id) {
    // Removes all content relating to the user.
  }
}

class Post {
  /* Represents a single upload.
   */
  static void create(String id) {

  }

  static void delete(String id) {

  }

  static void purge(String id) {

  }

}

class Comment {
  /* Represents a comment on a post.
   */
  static void create(String id) {

  }

  static void delete(String id) {

  }

  static void purge(String id) {

  }
}

class Conversation {
  /* Represents a conversation between two users.
   */

  static void create(String id) {

  }

  static void delete(String id) {

  }

  static void purge(String id) {

  }
}
