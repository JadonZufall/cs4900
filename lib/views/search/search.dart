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

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange); // Remove listener on dispose
    _focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {}); // Trigger rebuild to show/hide user list
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  void _navigateToProfile(String uid) {
    log('Navigating to profile with userId: $uid');
    Navigator.pushNamed(context, RouteNames.publicProfileRoute, arguments: {'userId': uid});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Usernames'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: _onSearchChanged, // Update the search text
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search username',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[800],
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
          // Only show the user list if the search field is focused
          if (_focusNode.hasFocus || searchText.isNotEmpty)
            Expanded(
              child: SearchHelpers.get(searchText, _focusNode, RouteNames.publicProfileRoute)
            ),
        ],
      ),
    );
  }
}
