import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final FirebaseFirestore db = FirebaseFirestore.instance;

class LikeButtonComponent extends StatefulWidget {
  final String imageId;
  final bool startLiked;
  const LikeButtonComponent({super.key, required this.imageId, required this.startLiked});

  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButtonComponent> {
  late bool isLiked;

  Future<void> _likeImage() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      log("Not authorized to like image.");
      return;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await db.collection("Users").doc(uid).get();
    List<dynamic> userLikes;
    if (!userSnapshot.data()!.keys.contains("likes")) {
      userLikes = [];
    }
    else {
      userLikes = userSnapshot.get("likes");
    }
    if (!userLikes.contains(widget.imageId)) {
      userLikes.add(widget.imageId);
      await db.collection("Users").doc(uid).update({"likes": userLikes});
    }
    var imageSnapshot = await db.collection("Images").doc(widget.imageId).get();
    List<dynamic> imageLikes;
    if (!imageSnapshot.data()!.keys.contains("likes")) {
      imageLikes = [];
    }
    else {
      imageLikes = imageSnapshot.get("likes");
    }
    if (!imageLikes.contains(uid)) {
      imageLikes.add(uid);
      await db.collection("Images").doc(widget.imageId).update({"likes": imageLikes});
    }
    log("Image liked");
  }

  Future<void> _unlikeImage() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      log("No authentication");
      return;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var userSnapshot = await db.collection("Users").doc(uid).get();
    List<dynamic> userLikes;
    if (!userSnapshot.data()!.keys.contains("likes")) {
      userLikes = <String>[];
    }
    else {
      userLikes = userSnapshot.get("likes");
    }
    if (userLikes.contains(widget.imageId)) {
      userLikes.remove(widget.imageId);
      await db.collection("Users").doc(uid).update({"likes": userLikes});
    }
    var imageSnapshot = await db.collection("Images").doc(widget.imageId).get();
    List<dynamic> imageLikes;
    if (!imageSnapshot.data()!.keys.contains("Likes")) {
      imageLikes = <String>[];
    }
    else {
      imageLikes = imageSnapshot.get("likes");
    }
    if (imageLikes.contains(uid)) {
      imageLikes.remove(uid);
      await db.collection("Images").doc(widget.imageId).update({"likes": imageLikes});
    }
    log("Image unliked");
  }

  void _onPressed() async {
    log("Like button pressed");
    if (isLiked) {
      var _ = await _unlikeImage();
      setState(() {isLiked = !isLiked;});
    }
    else {
      var _ = await _likeImage();
      setState(() {isLiked = !isLiked;});
    }

  }

  @override
  void initState() {
    super.initState();
    isLiked = widget.startLiked;
  }

  @override
  Widget build(BuildContext context) {
    log("Built");


    return IconButton(
        icon: Icon(
          Icons.favorite_outline,
          size: 25,
          color: isLiked ? Colors.red : Colors.white,
        ),
        onPressed: _onPressed,
    );
  }

}