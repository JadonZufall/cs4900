import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/util/app_colors.dart';
import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';

class InboxBlob extends StatefulWidget {
  final String? recipientUid;
  const InboxBlob({super.key, this.recipientUid});

  @override
  InboxBlobState createState() => InboxBlobState();
}

class InboxBlobState extends State<InboxBlob> {
  User? current = FirebaseAuth.instance.currentUser;
  var _future;
  UserInformation? recipient;

  @override
  void initState() {
    super.initState();
    _future = getOtherUserData();
  }

  Future<Map<String, dynamic>> getOtherUserData() async {
    recipient = new UserInformation(widget.recipientUid!);
    var docSnapshot = await FirebaseFirestore.instance.collection("Conversations/${current!.uid}/OpenConversations").doc(recipient!.uid).get();

    Map<String, dynamic> resultData = <String, dynamic> {
      "lastMessage": docSnapshot.get("lastMessage"),
      "timeStamp": docSnapshot.get("timeStamp"),
      "recipientPfp": Image.network(await recipient!.getProfilePicture()),
      "recipientName": await recipient!.getUsername(),
      "recipientUid": recipient!.uid
    };
    return resultData;
  }

  Widget createBlobStreamBuilder(context, Map<String, dynamic> inboxData) {
    Widget loadingState = const Center(child: CircularProgressIndicator());

    UserInformation recipient = new UserInformation(widget.recipientUid!);
    User? current = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("Conversations/${current!.uid}/OpenConversations").doc(recipient!.uid).snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return createBlob(context, inboxData);
          }
          else if (snapshot.hasData) {
            inboxData["lastMessage"] = snapshot.data!.get("lastMessage");
          }
          return createBlob(context, inboxData);
        })
    );
  }

  Widget createBlob(context, Map<String, dynamic> inboxData) {
    Center recipientInformation = Center(child: Container(
      margin: EdgeInsets.only(left:15),
      child: Row (
        children: [
          ClipOval(
              child: SizedBox(
                width: 35, height: 35,
                child: inboxData["recipientPfp"],
              )
          ),
          Container(
              margin: EdgeInsets.only(left:15, top: 5),
              child: Column(
                  children: [
                    Text(
                      inboxData["recipientName"] ?? "???",
                      style: const TextStyle(fontSize:16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      inboxData["lastMessage"] ?? "???",
                      style: const TextStyle(fontSize:16, color: Colors.white),
                      textAlign: TextAlign.left,
                    )
                  ]
              )
          ),
        ],
      ),));

    return GestureDetector (
      child: Container(
        margin: EdgeInsets.only(top:10),
        decoration: BoxDecoration(
            color: AppColors.darken(AppColors.backgroundColor, 0.05),
            borderRadius: BorderRadius.circular(10)
        ),
        width: 375, height: 60,
        child: recipientInformation,
      ),
      onTap: () {
        Navigator.pushNamed(
            context,
            RouteNames.directMessageRoute,
            arguments: {'userId': widget.recipientUid!}
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingState = const Center(child: CircularProgressIndicator());

    FutureBuilder<Map<String, dynamic>> builder = FutureBuilder<Map<String, dynamic>> (
        future: _future,
        builder: ( context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return loadingState;
            }
            return createBlobStreamBuilder(context, snapshot.data!);
          }
          else {
            return loadingState;
          }
        }
    );

    return builder;
  }
}