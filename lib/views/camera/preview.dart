import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/views/camera/upload.dart';
import 'package:cs4900/views/camera/edit.dart';

class PreviewPictureScreen extends StatelessWidget {
  final String imagePath;
  const PreviewPictureScreen({super.key, required this.imagePath});

  Future<void> _upload() async {
    log("Upload started");
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference =
        FirebaseStorage.instance.ref().child("images/$filename");
    UploadTask uploadTask = storageReference.putFile(File(imagePath));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      log("Image upload completed.");
    });
    String imageURL = await taskSnapshot.ref.getDownloadURL();
    User? localUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("images").add({
      "url": imageURL,
      "author": localUser.uid,
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(localUser.uid)
        .collection("images")
        .add({
      "url": imageURL,
      "author": localUser.uid,
    });
    log("image uploaded");
    navigatorKey.currentState?.pushReplacementNamed(RouteNames.homeScreenRoute);
  }

  void _retake() {
    navigatorKey.currentState?.pop();
    // navigatorKey.currentState?.pushNamed(RouteNames.uploadScreenRoute);
  }

  void _edit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Row(children: [
            Center(
              child: ElevatedButton(
                onPressed: _retake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UploadScreen(imagePath: imagePath),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                ),
                child: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditScreen(imagePath: imagePath),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                ),
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
