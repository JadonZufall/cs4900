import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';
import 'package:path/path.dart';
import 'package:cs4900/components/follow_button.dart';

class PublicProfileScreen extends StatefulWidget {  
  final String userId; // Accept userId to load the profile

  const PublicProfileScreen({super.key, required this.userId});

    @override
    PublicProfileScreenState createState() => PublicProfileScreenState();
}

class PublicProfileScreenState extends State<PublicProfileScreen> {
  late UserInformation profileUserInformation;
  late UserInformation currentUserInformation = UserInformation(FirebaseAuth.instance.currentUser!.uid);
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    profileUserInformation = UserInformation(widget.userId);
  }

  @override
  void dispose() {

    super.dispose();
  }

  Future<bool> _isFollowing() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      log("Not authorized.");
      return false;
    }

    // var imageSnapshot = await db.collection("Images").doc(imageId).get();
    // String authorId = imageSnapshot.get("author");

    var uid = FirebaseAuth.instance.currentUser!.uid;
    var userSnapshot = await db.collection("Users").doc(uid).get();
    if (!userSnapshot.data()!.keys.contains("following")) {
      log("Usersnapshot does not contains followers, so must not be following.");
      return false;
    }
    List<dynamic> userFollowing = userSnapshot.get("following");
    if (userFollowing.contains(profileUserInformation.uid)) {
      return true;
    }
    return false;
  }

  void _followButton() async
  {
    // Reference to Firestore
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the users collection
    final CollectionReference usersCollection = firestore.collection('Users');

    // Update the following array for the current user
    await usersCollection.doc(currentUserInformation.uid).update({
      'following': FieldValue.arrayUnion([profileUserInformation.uid]),
    }).catchError((error) {
      log("Failed to follow user: $error");
    });

    // Update the followers array for the target user
    await usersCollection.doc(profileUserInformation.uid).update({
      'followers': FieldValue.arrayUnion([currentUserInformation.uid]),
    }).catchError((error) {
      log("Failed to add follower: $error");
    });
  }

  void _messageButton()
  {

  }

  @override
  Widget build(BuildContext context) {
    // Get the current route name
    String? routeName = ModalRoute.of(context)?.settings.name;

    // You can log the route name
    log("Current route name: $routeName");
    TextStyle usernameTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
    TextStyle bioTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    Center loadingIndicator = const Center(child: CircularProgressIndicator());

    FutureBuilder<String> usernameField = FutureBuilder<String>(
        future: profileUserInformation.getUsername(),
        builder: (context, snapshot) {
          log("Future data = ${snapshot.data}");
          log("${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.done) {
            return Text("${snapshot.data}", style: usernameTextStyle);
          }
          else { return loadingIndicator; }
    });
    FutureBuilder<String?> bioField = FutureBuilder<String?>(
      future: profileUserInformation.getBio(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Check if snapshot.data is null
          if (snapshot.data == "ERROR" || snapshot.data!.isEmpty) {
            return Text("No bio available", style: bioTextStyle); // Default message if null or empty
          } else {
            return Text(snapshot.data!, style: bioTextStyle); // Display the bio
          }
        } else {
          return loadingIndicator; // Show loading indicator while fetching data
        }
      },
    );
    FutureBuilder<String> profilePictureField = FutureBuilder<String>(
      future: profileUserInformation.getProfilePicture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(snapshot.data ?? ""),
          );
        }
        else {
          return loadingIndicator;
        }
      }
    );
    FutureBuilder<List<Map<String, dynamic>>> uploadedPicturesField = FutureBuilder<List<Map<String, dynamic>>> (
      future: profileUserInformation.getUploadedImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Image> images = [];

          for (var i = 0; i < snapshot.data!.length; i++) {
            Map<String, dynamic>? pair = snapshot.data?.elementAt(i);
            String url = pair?["url"];
            images.add(Image.network(
              url,
              fit: BoxFit.cover,
            ));
          }

          return Expanded(
            child: Container(
              color: const Color.fromRGBO(18, 25, 33, 1),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
                  itemCount: images.length,
                  itemBuilder: (context, index) {

                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: images.elementAt(index),
                    );
                  }
              ),
            )
          );
        }
        else {
          return loadingIndicator;
        }
      },
    );



    FutureBuilder<String> uploadCount = FutureBuilder<String>(
      future: profileUserInformation.getUploadCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildStatColumn("Posts", snapshot.data ?? "?");
        }
        else {
          return _buildStatColumn("Posts", "?");
        }
      }
    );

    FutureBuilder<int> followerCount = FutureBuilder<int>(
      future: profileUserInformation.getFollowers().then((followers) => followers.length),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildStatColumn("Followers", snapshot.data?.toString() ?? "0");
        } else {
          return _buildStatColumn("Followers", "?");
        }
      }
    );

    FutureBuilder<int> followingCount = FutureBuilder<int>(
      future: profileUserInformation.getFollowing().then((following) => following.length),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildStatColumn("Following", snapshot.data?.toString() ?? "0");
        } else {
          return _buildStatColumn("Following", "?");
        }
      }
    );

    var followButton = FutureBuilder<bool>(
      future: _isFollowing(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          log("Building follow button");
          return FollowButtonComponent(userUid: profileUserInformation.uid, startFollowing: snapshot.data ?? false);
        }
        return loadingIndicator;
      },
    );

    Column body = Column(
      children: [
        Container(
          color: const Color.fromRGBO(18, 25, 33, 1),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profilePictureField,
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    usernameField,
                    const SizedBox(height: 4.0),
                    bioField,
                    const SizedBox(height: 8.0),
                    // -------------------------------------------------------
                    // This is all filler profile stats information that will need to be replaced with proper user data from firebase
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        uploadCount,
                        
                        
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('Users').doc(profileUserInformation.uid).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _buildStatColumn("Followers", "?");
                            } else if (snapshot.hasError) {
                              return _buildStatColumn("Followers", "Error");
                            } else if (snapshot.hasData) {
                              // Safely cast the data to a Map<String, dynamic>
                              var userData = snapshot.data!.data() as Map<String, dynamic>;
                              var followers = userData['followers'] ?? [];
                              return _buildStatColumn("Followers", (followers.length).toString());
                            } else {
                              return _buildStatColumn("Followers", "0");
                            }
                          },
                        ),
                        
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('Users').doc(profileUserInformation.uid).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _buildStatColumn("Following", "?");
                            } else if (snapshot.hasError) {
                              return _buildStatColumn("Following", "Error");
                            } else if (snapshot.hasData) {
                              // Safely cast the data to a Map<String, dynamic>
                              var userData = snapshot.data!.data() as Map<String, dynamic>;
                              var following = userData['following'] ?? [];
                              return _buildStatColumn("Following", (following.length).toString());
                            } else {
                              return _buildStatColumn("Following", "0");
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ElevatedButton(
            //   onPressed: _followButton,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
            //     minimumSize: const Size(120, 48), // Set the minimum size
            //   ),
            //   child: const Text("Follow", style: TextStyle(color: Colors.white)),
            // ),
            followButton,
            ElevatedButton(
              onPressed: _messageButton,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                minimumSize: const Size(120, 48), // Set the minimum size
              ),
              child: const Text("Message", style: TextStyle(color: Colors.white))
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        uploadedPicturesField,
      ],
    );


    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: body,
    );
  }


  Widget _buildStatColumn(String label, String count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count, // converts int data for followers / posts / following to string
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.white
          ),
        ),
      ],
    );
  }
}