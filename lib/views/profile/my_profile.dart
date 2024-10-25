import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';


class MyProfileScreen extends StatefulWidget {
    const MyProfileScreen({super.key});

    @override
    MyProfileScreenState createState() => MyProfileScreenState();
}

class MyProfileScreenState extends State<MyProfileScreen> {
  late UserInformation userInformation = UserInformation(FirebaseAuth.instance.currentUser!.uid);


  void _editProfileButton() {
    navigatorKey.currentState?.pushNamed(RouteNames.myProfileSettingsRoute);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        future: userInformation.getUsername(),
        builder: (context, snapshot) {
          log("Future data = ${snapshot.data}");
          log("${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.done) {
            return Text("${snapshot.data}", style: usernameTextStyle);
          }
          else { return loadingIndicator; }
    });
    FutureBuilder<String> bioField = FutureBuilder<String>(
        future: userInformation.getBio(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text("${snapshot.data}", style: bioTextStyle);
          }
          else { return loadingIndicator; }
        }
    );
    FutureBuilder<String> profilePictureField = FutureBuilder<String>(
      future: userInformation.getProfilePicture(),
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
      future: userInformation.getUploadedImages(),
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
                        _buildStatColumn('Posts', 0),
                        _buildStatColumn('Followers', 0),
                        _buildStatColumn('Following', 0),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          color: const Color.fromRGBO(18, 25, 33, 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('Edit Profile', _editProfileButton),
              ],
            ),
          ),
        ),
        uploadedPicturesField,
      ],
    );


    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: body,
      floatingActionButton: FloatingActionButton(onPressed: _editProfileButton, child: const Icon(Icons.settings)),
    );
  }


  Widget _buildStatColumn(String label, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          count.toString(), // converts int data for followers / posts / following to string
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

  Widget _buildActionButton(String title, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
      ),
      child: Text(
          title,
          style: const TextStyle(color: Colors.white)
      ),
    );
  }
}