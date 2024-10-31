import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';
import 'package:cs4900/views/profile/public_profile.dart';

class SearchHelpers {
  static Stream<QuerySnapshot> getFilteredUsers(searchText, focusNode) {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (searchText.isEmpty && focusNode.hasFocus) {
      // Show all users if the search bar is focused and text is empty
      return FirebaseFirestore.instance
          .collection('Users')
          .where(FieldPath.documentId, isNotEqualTo: currentUserUid) // Exclude current user
          .snapshots();
    } else if (searchText.isNotEmpty) {
      // Perform a filtered search
      return FirebaseFirestore.instance
          .collection('Users')
          .where('username', isGreaterThanOrEqualTo: searchText)
          .where('username', isLessThanOrEqualTo: '$searchText\uf8ff')
          .where(FieldPath.documentId, isNotEqualTo: currentUserUid) // Exclude current user
          .snapshots();
    }
    return Stream.empty(); // Return an empty stream if the search field is not focused and empty
  }
  static StreamBuilder<QuerySnapshot> get(searchText, focusNode, String route) {
    return StreamBuilder<QuerySnapshot>(
      stream: SearchHelpers.getFilteredUsers(searchText, focusNode),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return Center(child: Text('An error occurred', style: TextStyle(color: Colors.white)));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No users found', style: TextStyle(color: Colors.white)),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var uid = doc.id;
            UserInformation userInformation = UserInformation(uid);
            log('Found profile with userId: $uid');
            var username = doc['username'];
            // var profilePictureUrl = doc['profile_picture'];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: FutureBuilder<String>(
                future: userInformation.getProfilePicture(), // Assuming this field exists in your Firestore document
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey, // Placeholder color
                        child: CircularProgressIndicator(), // Loading indicator
                      ),
                      title: Text(username, style: TextStyle(color: Colors.white)),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(snapshot.data ?? ''), // Load the profile picture
                        child: snapshot.data == null ? Icon(Icons.person) : null, // Fallback icon
                      ),
                      title: Text(username, style: TextStyle(color: Colors.black)),
                      onTap: () {
                        log('Navigating to profile with userId: $uid');
                        Navigator.pushNamed(
                          context,
                          route,
                          arguments: {'userId': uid}, // Pass the user ID as an argument
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}