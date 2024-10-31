import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cs4900/main.dart';

enum UploadType { imageUpload, profilePictureUpload }

class UploadScreen extends StatefulWidget {
  final String imagePath;
  final UploadType type;

  UploadScreen({super.key, required this.imagePath, required this.type});

  @override
  State<UploadScreen> createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {
  double uploadPercentage = 0.0;
  UploadTask? _uploadTask = null;
  Timer? timer;

  void _doneButton() {
    navigatorKey.currentState?.pushNamed(RouteNames.homeScreenRoute);
  }

  Future<String> _uploadProfilePicture() async {
    log("Upload Profile Picture Started");
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child("ProfilePictures/$filename");
    File file = File(widget.imagePath);
    UploadTask uploadTask = storageReference.putFile(file);
    _uploadTask = uploadTask;
    log("Bound uploadtask");
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() { log("Image upload completed."); });
    String imageURL = await taskSnapshot.ref.getDownloadURL();
    User? localUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("Users").doc(localUser.uid).update({"profile_picture": imageURL});
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    return imageURL;
  }

  Future<String> _upload() async {
    log("Upload started");
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child("Images/$filename");
    File file = File(widget.imagePath);
    UploadTask uploadTask = storageReference.putFile(file);
    _uploadTask = uploadTask;
    log("Bound uploadtask");
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() { log("Image upload completed."); });
    String imageURL = await taskSnapshot.ref.getDownloadURL();
    User? localUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("Images").add(
        {
          "url": imageURL,
          "author": localUser.uid,
          "timeUploaded": DateTime.now(),
        }
    );
    await FirebaseFirestore.instance.collection("Users").doc(localUser.uid).collection("images").add(
        {
          "url": imageURL,
          "author": localUser.uid,
          "timeUploaded": DateTime.now(),
        }
    );
    log("image uploaded");
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    navigatorKey.currentState?.pop();
    return imageURL;
  }

  void updateProgress(Timer t) {
    if (_uploadTask == null) {
      log("No upload task?");
      return;
    }
    int? bytesOut = _uploadTask!.snapshot.bytesTransferred;
    int? bytesTotal = _uploadTask!.snapshot.totalBytes;


    log("$bytesOut / $bytesTotal");
    double? progress = (bytesOut!.toDouble()) / (bytesTotal!.toDouble());
    uploadPercentage = progress ?? 0.0;
    log("$uploadPercentage");
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 500), updateProgress);
  }

  @override
  void dispose() {
    log("Killing upload task & timer");
    timer?.cancel();
    _uploadTask?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.imagePath);
    AppBar appBar = AppBar(
      title: const Text("Upload"),
      centerTitle: true,
    );

    FutureBuilder<String> uploadProgress = FutureBuilder<String>(
      future: widget.type == UploadType.imageUpload ? _upload() : _uploadProfilePicture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ElevatedButton(
            onPressed: _doneButton,
            child: Text("Done ${snapshot.data}"),
          );
        }
        else {
          int? bytesOut = _uploadTask?.snapshot.bytesTransferred;
          int? bytesTotal = _uploadTask?.snapshot.totalBytes;
          double? progress = (bytesOut!.toDouble()) / (bytesTotal!.toDouble());
          uploadPercentage = progress ?? 0.0;
          log("$uploadPercentage");
          return Center(
            child: CircularProgressIndicator(value: uploadPercentage,),
          );
        }
      }
    );

    Column body = Column(
      children: [
        Image.file(File(widget.imagePath)),
        uploadProgress,
      ]
    );

    Scaffold result = Scaffold(
      appBar: appBar,
      body: body,
    );

    return result;
  }
}