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
    }
    catch (e) {
      return "ERROR_";
    }
  }

  Future<String> getProfilePicture() async {
    snapshot ??= db.collection("Users").doc(uid).get();
    try {
      return await (await snapshot)!.get("profile_picture") ?? "https://shorturl.at/lj8F7";
    } on FirebaseException catch (e) {
      if (e.code == "storage/object-not-found") {
        log("Defaulting users profile picture to default profile picture.");
        await db.collection("Users").doc(uid).update({"profile_picture": "https://shorturl.at/lj8F7"});
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

  Future<List<String>> getUploadedImages() async {
    snapshot ??= db.collection("Users").doc(uid).get();
    return [];
  }

  UserInformation(this.uid) {
    func() async => await db.collection("Users").doc(uid).get();
    snapshot = func();
  }
}


class MyProfileScreen extends StatefulWidget {
    const MyProfileScreen({super.key});

    @override
    MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  late UserInformation userInformation = UserInformation(FirebaseAuth.instance.currentUser!.uid);


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle usernameTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    TextStyle bioTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    Center loadingIndicator = const Center(child: CircularProgressIndicator());

    FutureBuilder<String> usernameField = FutureBuilder<String>(
        future: userInformation.getUsername(),
        builder: (context, snapshot) {
          log("Future data = ${snapshot.data}");
          log("${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.done) {
            return Text("${snapshot.data}", style: usernameTextStyle);
          }
          else { return loadingIndicator; }
    });
    FutureBuilder<String> bioField = FutureBuilder<String>(
        future: userInformation.getBio(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text("${snapshot.data}", style: bioTextStyle);
          }
          else { return loadingIndicator; }
        }
    );
    FutureBuilder<String> profilePictureField = FutureBuilder<String>(
      future: userInformation.getProfilePicture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Image.network("${snapshot.data}");
        }
        else { return loadingIndicator; }
      }
    );

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: Column(
        children: [
          usernameField,
          bioField,
          profilePictureField,
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        log(await userInformation.getUsername());
      }),
    );
  }
}