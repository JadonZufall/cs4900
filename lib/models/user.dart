import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class UserInformation {
  String uid;
  Future<DocumentSnapshot<Object?>>? snapshot;

  Future<String> getUsername() async {
    snapshot ??= db.collection("Users").doc(uid).get();
    try {
      return await (await snapshot)!.get("username") ?? "ERROR";
    }
    catch (e) {
      return "ERROR_";
    }
  }

  Future<String> getBio() async {
    snapshot ??= db.collection("Users").doc(uid).get();
    try {
      return await (await snapshot)!.get("bio") ?? "ERROR";
    } on FirebaseException catch (e) {
      if (e.code == "stroage/object-not-found") {
        log("Defaulting users bio to default bio message");
        await db.collection("Users").doc(uid).update({"bio": "Please fill out bio..."});
        snapshot = db.collection("Users").doc(uid).get(); // Refresh the snapshot to the new version.
        return "Please fill out bio...";
      }
      else {
        log("${e.code}: ${e.message}");
        return "ERROR";
      }
    }
    catch (e) {
      return "ERROR_";
    }
  }

  Future<void> setBio(String value) async {
    return await db.collection("Users").doc(uid).update({"bio": value});
  }

  Future<void> setUsername(String value) async {
    return await db.collection("Users").doc(uid).update({"username": value});
  }

  Future<String> getProfilePicture() async {
    snapshot ??= db.collection("Users").doc(uid).get();
    try {
      return await (await snapshot)!.get("profile_picture") ?? "https://shorturl.at/lj8F7";
    } on FirebaseException catch (e) {
      if (e.code == "storage/object-not-found") {
        log("Defaulting users profile picture to default profile picture.");
        await db.collection("Users").doc(uid).update({"profile_picture": "https://shorturl.at/lj8F7"});
        snapshot = db.collection("Users").doc(uid).get(); // Refresh the snapshot to the new version.
        return "https://shorturl.at/lj8F7";
      }
      else {
        log("${e.code}: ${e.message}");
        return "https://shorturl.at/GxTbD";
      }
    }
    catch (e) {
      log("$e");
      return "https://shorturl.at/GxTbD";
    }
  }

  Future<List<Map<String, dynamic>>> getUploadedImages() async {
    snapshot ??= db.collection("Users").doc(uid).get();

    List<Map<String, dynamic>> result = [];
    QuerySnapshot<Map<String, dynamic>> imageSnapshot = await db.collection("Users").doc(uid).collection("images").get();
    log(imageSnapshot.docs.length.toString());
    for (var i = 0; i < imageSnapshot.docs.length; i++) {

      QueryDocumentSnapshot<Map<String, dynamic>> doc = imageSnapshot.docs.elementAt(i);
      result.add({"id": doc.id, "url": doc.get("url")});
    }
    return result;
  }

  Future<String> getUploadCount() async {
    QuerySnapshot<Map<String, dynamic>> imageSnapshot = await db.collection("Users").doc(uid).collection("images").get();
    return imageSnapshot.size.toString();
  }

  UserInformation(this.uid) {
    func() async => await db.collection("Users").doc(uid).get();
    snapshot = func();
  }
}
