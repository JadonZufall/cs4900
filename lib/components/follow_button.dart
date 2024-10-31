import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
final FirebaseFirestore db = FirebaseFirestore.instance;

class FollowButtonComponent extends StatefulWidget {
  final String imageId;
  final bool startFollowing;
  const FollowButtonComponent({super.key, required this.imageId, required this.startFollowing});

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

  Future<void> _unfollow() async {

  }

  Future<void> _follow() async {

  }

  @override
  Widget build(BuildContext context) {
    log("Built");

    return ElevatedButton(
        onPressed: isFollowing ? _unfollow : _follow,
        child: Text(isFollowing ? "Unfollow" : "Follow")
    );
  }

}