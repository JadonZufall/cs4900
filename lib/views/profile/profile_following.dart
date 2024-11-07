import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';
import 'package:cs4900/views/profile/public_profile.dart';
import 'package:cs4900/util/search_util.dart';


class FollowingPage extends StatefulWidget {  
  final String userId; // Accept userId to load the profile

  const FollowingPage({super.key, required this.userId});

    @override
    FollowingPageState createState() => FollowingPageState();
}

class FollowingPageState extends State<FollowingPage> with RouteAware {
  late UserInformation profileUserInformation;
  final FirebaseFirestore db = FirebaseFirestore.instance;  
  List<Map<String, dynamic>> following = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _getFollowing();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cast the route to PageRoute
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // Called when returning to this screen
    _getFollowing(); // Refresh followers list
  }

  Future<void> _getFollowing() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();

      List<String> followerIds = List<String>.from(userDoc['following'] ?? []);

       if (followerIds.isEmpty) {
        log("No followers found.");
        // If there are no followers, set loading to false and return
        setState(() {
          following = [];
          isLoading = false;
        });
        return;
      }

      // Fetch details for each follower
      List<Map<String, dynamic>> followerDetails = [];
      for (var uid in followerIds) {
        DocumentSnapshot followerDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .get();

        if (followerDoc.exists) {
          followerDetails.add({
            'uid': uid,
            'username': followerDoc['username'],
            'profile_picture': followerDoc['profile_picture'],
          });
          log('Found profile with userId: $uid');
        }
      }

      setState(() {
        following = followerDetails;
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching following: $e");
      isLoading = false;
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Following"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : following.isEmpty
              ? const Center(
                  child: Text(
                    'No Following',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                itemCount: following.length,
                itemBuilder: (context, index) {
                  var follower = following[index];
                  var uid = follower['uid'];
                  var username = follower['username'];
                  var profilePictureUrl = follower['profile_picture'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: profilePictureUrl != null
                              ? NetworkImage(profilePictureUrl)
                              : null,
                          backgroundColor: Colors.grey, // Placeholder color
                          child: profilePictureUrl == null
                              ? Icon(Icons.person)
                              : null, // Fallback icon
                        ),
                        title: Text(username, style: TextStyle(color: Colors.black)),
                        onTap: () {
                          if (uid == FirebaseAuth.instance.currentUser?.uid) {
                            log('Navigating to My Profile');
                            Navigator.pushNamed(context, RouteNames.myProfileScreenRoute);
                          } else {
                            log('Navigating to Public Profile with userId: $uid');
                            Navigator.pushNamed(
                              context,
                              RouteNames.publicProfileRoute,
                              arguments: {'userId': uid as String},
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
