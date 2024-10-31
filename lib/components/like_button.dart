import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final FirebaseFirestore db = FirebaseFirestore.instance;

class LikeButtonComponent extends StatefulWidget {
  final String imageId;
  const LikeButtonComponent({super.key, required this.imageId});

  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButtonComponent> {
  bool isLiked = false;

  Future<void> _likeImage() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Users").doc(uid).collection("data").doc("likes").update({widget.imageId: true});
    await db.collection("Images").doc(uid).collection("data").doc("likes").update({uid: true});
  }

  Future<void> _unlikeImage() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return;
    }
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await db.collection("Users").doc(uid).collection("data").doc("likes").update({widget.imageId: null});
    await db.collection("Images").doc(uid).collection("data").doc("likes").update({uid: null});
  }

  void _onPressed() async {
    log("Like button pressed");
    if (isLiked) {
      await _unlikeImage();
    }
    else {
      await _likeImage();
    }
    setState(() {isLiked = !isLiked;});

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