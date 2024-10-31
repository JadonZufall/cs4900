import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final FirebaseFirestore db = FirebaseFirestore.instance;

class FollowButtonComponent extends StatefulWidget {
  final String? imageId; // Optional Image ID
  final String? userUid; // Optional User UID
  final bool startFollowing;
  const FollowButtonComponent({super.key, this.imageId, required this.startFollowing, this.userUid});

  @override
  FollowButtonState createState() => FollowButtonState();
}

class FollowButtonState extends State<FollowButtonComponent> {
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.startFollowing;
  }

  Future<String> _getAuthorId() async {
    if (widget.userUid != null) {
      // Use provided userUid directly
      return widget.userUid!;
    }
    var snapshot = await db.collection("Images").doc(widget.imageId).get();
    String authorUid = snapshot.get("author");
    return authorUid;
  }

  Future<List<dynamic>> _getAuthorFollowers() async {
    String authorUid = await _getAuthorId();
    var snapshot = await db.collection("Users").doc(authorUid).get();
    if (!snapshot.data()!.keys.contains("followers")) {
      return [];
    }
    else {
      return snapshot.get("followers");
    }
  }

  Future<List<dynamic>> _getFollowing() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var snapshot = await db.collection("Users").doc(uid).get();
    if (!snapshot.data()!.keys.contains("following")) {
      return [];
    }
    else {
      return snapshot.get("following");
    }
  }

  Future<void> _setAuthorFollowers(List<dynamic> followers) async {
    String authorUid = await _getAuthorId();
    return await db.collection("Users").doc(authorUid).update({"followers": followers});
  }

  Future<void> _setFollowing(List<dynamic> following) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return await db.collection("Users").doc(uid).update({"following": following});
  }

  Future<void> _setUnfollow() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      log("No authentication");
      return;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String authorUid = await _getAuthorId();
    List<dynamic> following = await _getFollowing();
    List<dynamic> authorFollowers = await _getAuthorFollowers();
    if (following.contains(authorUid)) {
      following.remove(authorUid);
      await _setFollowing(following);
    }
    if (authorFollowers.contains(uid)) {
      authorFollowers.remove(uid);
      await _setAuthorFollowers(authorFollowers);
    }
    log("Unfollow");
  }

  Future<void> _setFollow() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      log("No authentication");
      return;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String authorUid = await _getAuthorId();
    List<dynamic> following = await _getFollowing();
    List<dynamic> authorFollowers = await _getAuthorFollowers();
    if (!following.contains(authorUid)) {
      following.add(authorUid);
      await _setFollowing(following);
    }
    if (!authorFollowers.contains(uid)) {
      authorFollowers.add(uid);
      await _setAuthorFollowers(authorFollowers);
    }
    log("Follow");
  }

  Future<void> _unfollow() async {
    var _ = await _setUnfollow();
    setState(() {isFollowing = false;});
  }

  Future<void> _follow() async {
    var _ = await _setFollow();
    setState(() {isFollowing = true;});
  }

  Future<bool> _isOwnPost() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      log("No authentication");
      return false;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String authorId = await _getAuthorId();
    if (uid == authorId) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    log("Built");
    var loadingIndicator = const CircularProgressIndicator();

    var future = FutureBuilder<bool>(future: _isOwnPost(), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == true) {
          return const Text("");
        }
        return ElevatedButton(
          onPressed: isFollowing ? _unfollow : _follow,
          child: Text(isFollowing ? "Unfollow" : "Follow")
        );
      }
      return loadingIndicator;
    });
    return future;


  }

}