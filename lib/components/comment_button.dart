import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/components/photo_display.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class Comment extends StatefulWidget {
  Comment({super.key});
  //String type;
  //String uid;

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final comment = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        color: Color.fromARGB(255, 38, 53, 70),
        height: 150, // Adjust height to fit your content
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: MediaQuery.of(context).size.width / 2 - 75,
              child: Container(
                width: 150,
                height: 4,
                color: Colors.black,
              ),
            ),

            // White comment input bar at the bottom
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 260,
                      child: TextField(
                        controller: comment,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    Icon(Icons.send)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

