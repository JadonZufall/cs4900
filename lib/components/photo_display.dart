import 'dart:developer';

import 'package:cs4900/components/follow_button.dart';
import 'package:cs4900/main.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/models/image.dart';
import 'package:cs4900/models/user.dart';
import 'package:cs4900/views/profile/public_profile.dart';
import 'package:path/path.dart';
import 'package:cs4900/components/like_button.dart';
import 'package:cs4900/components/comment_button.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
final FirebaseFirestore db = FirebaseFirestore.instance;

class PhotoDisplayComponent extends StatelessWidget {
  final String imageId;

  const PhotoDisplayComponent({super.key, required this.imageId});

  GestureTapCallback generateProfileFunc(BuildContext context, String uid) {
    void result() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PublicProfileScreen(userId: uid)));
    }
    return result;
  }

  Future<Map<String, dynamic>> buildFutureElements() async {
    ImageInformation imageInfo = ImageInformation(imageId);
    Map<String, dynamic>? imageData = await imageInfo.getImageInformation();
    UserInformation authorInformation = await imageInfo.getAuthorInformation();

    log("Image Data = " + imageData.toString());
    Map<String, dynamic> resultData = <String, dynamic> {
      "ImageID": imageId,
      "ImageURL": imageData!["url"],
      "AuthorUID": authorInformation.uid,
      "AuthorUsername": await authorInformation.getUsername(),
      "AuthorProfilePicture": await authorInformation.getProfilePicture(),
      "Likes": imageData["likes"].toString(),
      "Comments": imageData["Comments"] ?? [],
    };
    log("Result data = " + resultData.toString());
    return resultData;
  }

  Future<bool> _getStartLiked() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      log("Not authorized.");
      return false;
    }
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var userSnapshot = await db.collection("Users").doc(uid).get();

    if (!userSnapshot.data()!.keys.contains("likes")) {
      log("Usersnapshot does not contains likes so image is not liked.");
      return false;
    }
    List<dynamic> userLikes = userSnapshot.get("likes");
    log("Fetching likes");
    bool result = userLikes.contains(imageId);
    log(result? "true":"false");
    return result;
  }

  Future<bool> _isFollowing(String imageId) async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      log("Not authorized.");
      return false;
    }

    var imageSnapshot = await db.collection("Images").doc(imageId).get();
    String authorId = imageSnapshot.get("author");

    var uid = FirebaseAuth.instance.currentUser!.uid;
    var userSnapshot = await db.collection("Users").doc(uid).get();
    if (!userSnapshot.data()!.keys.contains("following")) {
      log("Usersnapshot does not contains followers, so must not be following.");
      return false;
    }
    List<dynamic> userFollowing = userSnapshot.get("following");
    if (userFollowing.contains(authorId)) {
      return true;
    }
    return false;
  }

  Widget buildWidget(BuildContext context, Map<String, dynamic> data) {
    log("widget data = ");
    log(data.toString());
    var loadingIndicator = const CircularProgressIndicator();

    var followButton = FutureBuilder<bool>(
      future: _isFollowing(imageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return FollowButtonComponent(imageId: imageId, startFollowing: snapshot.data ?? false);
        }
        return loadingIndicator;
      },
    );

    Center authorInformation =
      Center(child: ListTile(
        leading: ClipOval(
          child: SizedBox(
            width: 35, height: 35,
            child: Image.network(data["AuthorProfilePicture"] ?? ""),
          ),
        ),
        title: new GestureDetector(
            onTap: generateProfileFunc(context, data["AuthorUID"]),
            child: Text(
              data["AuthorUsername"] ?? "???",
              style: const TextStyle(fontSize: 13, color: Colors.white),
            )
        ),
        trailing: followButton,
      ),
    );

    Container top = Container(
      width: 375, height: 54,
      color: const Color.fromRGBO(18, 25, 33, 1),
      child: authorInformation,
    );

    Container middle = Container(
      width: 375, height: 375,
      child: Image.network(data["ImageURL"] ?? "", fit: BoxFit.cover)
    );

    FutureBuilder<bool> likeButton = FutureBuilder<bool>(
      future: _getStartLiked(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return LikeButtonComponent(imageId: imageId, startLiked: snapshot.data ?? false);
        }
        else {
          return const Icon(
              Icons.favorite_outline,
              size: 25,
              color: Colors.grey,
          );
        }
      }
    );

    IconButton commentButton = IconButton(
      icon: Image.asset(
        'assets/images/comment.webp',
        height: 28,
      ),
      onPressed: () {
        showBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (context){
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: DraggableScrollableSheet(
              maxChildSize: 0.5,
              initialChildSize: 0.5,
              minChildSize: 0.2,
              builder: (context, scrollController){
                return Comment(); //snapshot['postId'], 'posts'
              },
            ),
          );
        },);
      }
    );

    IconButton shareButton = IconButton(
      icon: Image.asset(
        'assets/images/send.png',
        height: 25,
      ),
      onPressed: () {

      }
    );

    Container bottom = Container(
      width: 375,
      color: const Color.fromRGBO(18, 25, 33, 1),
      child: Column(
        children: [
          SizedBox(width: 14),
          Row(
            children: [
              SizedBox(width: 14),
              likeButton,
              SizedBox(width: 17),
              commentButton,
              SizedBox(width: 17),
              shareButton,
            ],
          )
        ],
      ),
    );

    return Column(
      children: [
        top,
        middle,
        bottom
      ]
    );
  }

  Future<bool> Comments({
    required String comment,
    required String type,
    required String uidd,
  }) async{
    DocumentReference docRef = FirebaseFirestore.instance.collection('comments').doc();
    String commentUid = docRef.id;
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var userInfo = await db.collection("Users").doc(uid).get();
    await db.collection(type).doc(uidd).collection('comments').doc(uid).set({
      'comment': comment,
      'username': userInfo.get("username"),
      'profileImage': userInfo.get("profile_picture"),
      'CommentUid': commentUid,
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingState = const SizedBox(width: 375, height: 429, child: Center(child: CircularProgressIndicator()));

    FutureBuilder<Map<String, dynamic>> builder = FutureBuilder<Map<String, dynamic>> (
      future: buildFutureElements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            log("Error snapshot data is null");
            return loadingState;
          }
          return buildWidget(context, snapshot.data!);
        }
        else { return loadingState; }
      },
    );

    return Container(
      child: builder,
    );
  }


}