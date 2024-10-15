import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cs4900/main.dart';
import 'package:cs4900/auth.dart';

class MyProfileScreen extends StatefulWidget {

  MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String? username;
  String? bio;

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback(postFrameCallback,);


    // Update username field if the username is the initial empty value.
    if (username == null) {
      getLocalUsername().then(
        // Perform this after the username is fetched.
          (String name) {
            if (name == "") {
              // Redirect the user to the setup profile page.
              navigatorKey.currentState?.pushReplacementNamed(RouteNames.profileSetupScreenRoute);
            }
            else {
              setState(() {
                // Update the username field on the profile.
                username = name;
              });
              log("Updated username to $username");
            }
          }
      );
    }

    if (bio == null) {
      getLocalUserInfo().then(
          (Map<String, dynamic> userInfo) {

          }
      );
    }

    Text usernameField = Text(
        username!, // will need to be replaced with actual username from firebase
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
      ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromRGBO(18, 25, 33, 1),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/images/bloop.jpg'), // Will need to be replaced with actual profile images from firebase
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      usernameField,

                      const SizedBox(height: 4.0),
                      Text(
                        "REPLACE THE STRING", // Will need to be replaced with actual bio data from firebase
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white
                          ),
                      ),
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
          // Edit profile button
          // THIS WILL NEED TO BE IGNORED FOR NON-PROFILE OWNER VIEW
          Container(
              color: const Color.fromRGBO(18, 25, 33, 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton('Edit Profile'),
                ],
              ),
            ),
          ),
          // Posts -- WILL NEED TO BE EDITED TO SUPPORT NETWORK IMAGES
          Expanded(
            child: Container(
              color: const Color.fromRGBO(18, 25, 33, 1),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemCount: 25, // FILLER NUMBER, WILL NEED TO REPLACE WITH ACTUAL NUMBER OF POSTS FROM FIREBASE
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset( // will need to be replaced with Image.network?
                      'assets/images/bloop.jpg', // FILLER IMAGE JUST SO I COULD CHECK THE LAYOUT, WILL NEED TO BE REPLACED WITH POST IMAGES FROM FIREBASE
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildActionButton(String title) {
    return ElevatedButton(
      onPressed: () {},
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