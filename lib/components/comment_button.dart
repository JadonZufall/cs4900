import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

class Comment extends StatefulWidget {
  final String imageId;
  final String uid;

  Comment({required this.imageId, required this.uid, super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  final commentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        color: Colors.white,
        height: 200,
        child: Stack(
          children: [
            Positioned(
              top: 8,
              left: 140,
              child: Container(
                width: 100,
                height: 3,
                color: Colors.black,
              ),
            ),
            // Fetching comments for the specific image URL
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('Images')  // Assuming 'Images' is your main collection for images
                  .doc(widget.imageId)  // Using the image URL to fetch comments for that image
                  .collection('comments') // Sub-collection to store the comments for this image
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return commentItem(snapshot.data!.docs[index].data());
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 260,
                      child: TextField(
                        controller: commentController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Add a comment',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        if (commentController.text.isNotEmpty) {
                          _addComment(); // Handle adding the comment to Firestore
                        }
                        setState(() {
                          isLoading = false;
                          commentController.clear();
                        });
                      },
                      child: isLoading
                          ? SizedBox(
                              width: 10,
                              height: 10,
                              child: const CircularProgressIndicator(),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentItem(final snapshot) {
    return ListTile(
      leading: ClipOval(
        child: SizedBox(
          height: 35,
          width: 35,
          child: Image.network(
            snapshot['profileImage'],  // Replace CachedImage with Image.network
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        snapshot['username'],
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        snapshot['comment'],
        style: TextStyle(
          fontSize: 13,
          color: Colors.black,
        ),
      ),
    );
  }

  // Function to add a comment to Firestore
  Future<void> _addComment() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final commentText = commentController.text.trim();

    if (currentUser == null) return; // Ensure user is logged in
    DocumentSnapshot userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
    // Check if the document exists
    if (!userDoc.exists) {
      log('User document not found!');
      return; // Exit if the user document doesn't exist
    }

    // Log the entire user document to verify the data
    log('User Document: ${userDoc.data()}');
    // If user document exists, fetch their username and profileImage, otherwise use defaults
    final String username = userDoc.exists ? (userDoc['username'] ?? 'Anonymous') : 'Anonymous';
    final String profileImage = userDoc.exists ? (userDoc['profile_picture'] ?? 'https://via.placeholder.com/150') : 'https://via.placeholder.com/150';

    log('User Info:');
    log('UID: ${currentUser.uid}');
    log('Username: $username');
    log('Profile Image URL: $profileImage');
    log('Comment Text: $commentText');

    final newComment = {
      'username': username ?? 'Anonymous',
      'profileImage': profileImage ?? 'https://via.placeholder.com/150',
      'comment': commentText,
      'uid': currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Add the comment to the Firestore document for the specific image
    await _firestore
        .collection('Images')
        .doc(widget.imageId) // Using the image URL as the document ID
        .collection('comments')
        .add(newComment);
  }
}
