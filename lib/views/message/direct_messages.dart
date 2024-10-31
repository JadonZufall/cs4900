import 'dart:developer';
import 'dart:ffi';

import 'package:cs4900/views/message/single_message.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';
import 'package:cs4900/Util/app_colors.dart';

class DirectMessagesScreen extends StatefulWidget {
  final String recieverUserId;
  final DocumentReference<Map<String, dynamic>>? messageLogReference;

  const DirectMessagesScreen({super.key, required this.recieverUserId, this.messageLogReference});

  @override
  DirectMessagesScreenState createState() => DirectMessagesScreenState();
}

class DirectMessagesScreenState extends State<DirectMessagesScreen> {
  late TextEditingController _controller;
  DocumentReference<Map<String, dynamic>>? messageLogReference;
  List<dynamic> messages = [];
  bool newConversation = false;
  bool sentMessage = false;

  User? sender = FirebaseAuth.instance.currentUser!;


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {

    _controller.dispose();
    if (newConversation && !sentMessage) {
      FirebaseFirestore.instance.collection("MessageLogs").doc(messageLogReference!.id).delete();
      FirebaseFirestore.instance.collection("Conversations/${sender!.uid}/OpenConversations").doc(widget.recieverUserId).delete();
      FirebaseFirestore.instance.collection("Conversations/${widget.recieverUserId}/OpenConversations").doc(sender!.uid).delete();
    }
    super.dispose();

  }

  void _sendMessageButton(String value) async {
    sentMessage = true;
    _controller.clear();

    var message = {
      "MessageId": sender!.uid + "${messages.length}",
      "user": sender!.uid,
      "Message": value,
      "Timestamp": DateTime.now().millisecondsSinceEpoch.toString()
    };

    await FirebaseFirestore.instance.collection("MessageLogs").doc(messageLogReference!.id).update({
      "Messages": FieldValue.arrayUnion([message])
    });

    await FirebaseFirestore.instance.collection("Conversations/${sender!.uid}/OpenConversations").doc(widget.recieverUserId).set(
      {
        "lastMessage" : value,
        "timeStamp" : DateTime.now().microsecondsSinceEpoch.toString(),
      },
      SetOptions(merge: true)
    );
    await FirebaseFirestore.instance.collection("Conversations/${widget.recieverUserId}/OpenConversations").doc(sender!.uid).set(
        {
          "lastMessage" : value,
          "timeStamp" : DateTime.now().microsecondsSinceEpoch.toString(),
        },
        SetOptions(merge: true)
    );
    if (newConversation) {
      await FirebaseFirestore.instance.collection("Conversations").doc(sender!.uid).set(
          {
            "newConversations": FieldValue.arrayUnion([widget.recieverUserId])
          },
          SetOptions(merge: true)
      );
      await FirebaseFirestore.instance.collection("Conversations").doc(widget.recieverUserId).set(
          {
            "newConversations": FieldValue.arrayUnion([sender!.uid])
          },
          SetOptions(merge: true)
      );
    }

  }

  Future<Map<String, dynamic>> buildInfo() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("Conversations").doc(sender!.uid).collection("OpenConversations").doc(widget.recieverUserId).get();
    newConversation = !snap.exists;
    log(newConversation ? 'true': 'false');


    if (!newConversation) {
      DocumentSnapshot<Map<String, dynamic>>? snapshot = await FirebaseFirestore.instance.collection("Conversations").doc(sender!.uid).collection("OpenConversations").doc(widget.recieverUserId).get();
      messageLogReference = await FirebaseFirestore.instance.collection("MessageLogs").doc(snapshot!.get("MessageLog"));
      await FirebaseFirestore.instance.collection("MessageLogs").doc(messageLogReference!.id).update({
        "Messages": FieldValue.arrayUnion([])
      });
    }
    else {
      messageLogReference ??= await FirebaseFirestore.instance.collection("MessageLogs").add(
          {
            "Messages": [
            ]
          }
      );
      FirebaseFirestore.instance.collection("Conversations/${sender!.uid}/OpenConversations").doc(widget.recieverUserId).set(
        {
          "MessageLog": messageLogReference!.id
        },
      );
      FirebaseFirestore.instance.collection("Conversations/${widget.recieverUserId}/OpenConversations").doc(sender!.uid).set(
        {
          "MessageLog": messageLogReference!.id
        },
      );
    }

    UserInformation recipient = new UserInformation(widget.recieverUserId);
    UserInformation senderInformation = new UserInformation(sender!.uid);

    return <String, dynamic> {
      "recieverUsername": await recipient.getUsername(),
      "recieverPfp": Image.network(await recipient.getProfilePicture()),
      "senderPfp": Image.network(await senderInformation.getProfilePicture()),
    };
  }

  Widget buildWidget(Map<String, dynamic> recipientData) {
    Center recipientInformation = Center(child: ListTile (
      leading: ClipOval(
        child: SizedBox(
          width: 35, height: 35,
          child: recipientData["recieverPfp"] ?? "",
        )
      ),
      title: Text(
        recipientData["recieverUsername"] ?? "???",
        style: const TextStyle(fontSize:13, color: Colors.white),
      ),
    ),);

    Container top = Container(
      width: 375, height: 54,
      color: const Color.fromRGBO(18, 25, 33, 1),
      child: recipientInformation,
    );

    return Column(
      children: [
        top,
        messageScreenStreamBuilder(recipientData["senderPfp"]),
        buildMessageBar()
      ],
    );
  }

  Widget messageScreenStreamBuilder(Image senderPfp) {
    Widget loadingState = const Center(child: CircularProgressIndicator());

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("MessageLogs").doc(messageLogReference!.id).snapshots(),
      builder: ((BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          log("Error in message screen stream builder");
          return buildMessageScreen(senderPfp);
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return buildMessageScreen(senderPfp);
        }

        messages = snapshot.data!.get("Messages");

        return buildMessageScreen(senderPfp);
      }),
    );
  }

  Widget buildMessageBar() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded (
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Type Something...",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none
                        ),
                      )
                    ),
                    SizedBox(width: 15),
                    Container(
                      decoration: BoxDecoration(color:Colors.white, shape:BoxShape.circle),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue
                        ),
                        onPressed: () {_sendMessageButton(_controller.text.toString());},
                      )
                    )
                  ]
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildMessageScreen(Image senderPfp) {
    return Expanded(
      child: Container (
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          color: AppColors.darken(AppColors.backgroundColor, 0.05),
          child: CustomScrollView( slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return MessageBlob(currentUser: sender!.uid, messageSender: messages[messages.length - index - 1]["user"], senderProfilePicture: senderPfp, messageContents: messages[messages.length - index - 1]["Message"]);
              },
              childCount: messages.length),
            )
          ],
          reverse: true,)
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingState = const Center(child: CircularProgressIndicator());

    FutureBuilder<Map<String, dynamic>> builder = FutureBuilder<Map<String, dynamic>> (
        future: buildInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              log("Error: snapshot data is null");
              return loadingState;
            }
            return buildWidget(snapshot.data!);
          }
          else {
            return loadingState;
          }
        }
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Direct Message'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body:
        Container(child: builder),
    );
  }
}