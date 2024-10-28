
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/models/user.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;


class ImageInformation {
  String imageId;

  Future<UserInformation> getAuthorInformation() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection("Images").doc(imageId).get();
    String authorUID = await snapshot.get("author");
    return UserInformation(authorUID);
  }

  Future<Map<String, dynamic>?> getImageInformation() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection("Images").doc(imageId).get();
    log("getImageInformation = " + snapshot.data().toString());
    return snapshot.data();
  }


  Future<void> updateImageInformation(Map<Object, Object?> data) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection("Images").doc(imageId).get();
    String authorUID = await snapshot.get("Author");
    await db.collection("Users").doc(authorUID).collection("images").doc(imageId).update(data);
    return await db.collection("Images").doc(imageId).update(data);
  }

  ImageInformation(this.imageId) {

  }
}