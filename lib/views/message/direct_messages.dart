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
  bool newConversation = true;
  bool sentMessage = false;

  User? sender = FirebaseAuth.instance.currentUser!;

  void _asyncInit() async {
    await FirebaseFirestore.instance.collection("Conversations").doc(sender!.uid).collection("OpenConversations").doc(widget.recieverUserId).get().then((DocumentSnapshot docSnap){
      newConversation = !docSnap.exists;
      print(newConversation);
    });

    if (!newConversation) {
      DocumentSnapshot<Map<String, dynamic>>? snapshot = await FirebaseFirestore.instance.collection("Conversations").doc(sender!.uid).collection("OpenConversations").doc(widget.recieverUserId).get();
      messageLogReference = await FirebaseFirestore.instance.collection("MessageLogs").doc(snapshot!.get("MessageLog"));

      await messageLogReference!.get().then((DocumentSnapshot docSnap) {
        setState(() {
          messages = docSnap.get("Messages");
        });
      });
    }
    
    messageLogReference ??= await FirebaseFirestore.instance.collection("MessageLogs").add(
        {
          "Messages": [
          ]
        }
    );
    await FirebaseFirestore.instance.collection("Conversations/${sender!.uid}/OpenConversations").doc(widget.recieverUserId).set(
        {
          "MessageLog": messageLogReference!.id
        },
        SetOptions(merge: true)
    );
    await FirebaseFirestore.instance.collection("Conversations/${widget.recieverUserId}/OpenConversations").doc(sender!.uid).set(
        {
          "MessageLog": messageLogReference!.id
        },
        SetOptions(merge: true)
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    


    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncInit();
    });
  }

  void dispose() async{
    _controller.dispose();
    if (newConversation && !sentMessage) {
      await FirebaseFirestore.instance.collection("MessageLogs").doc(messageLogReference!.id).delete();
      await FirebaseFirestore.instance.collection("Conversations/${sender!.uid}/OpenConversations").doc(widget.recieverUserId).delete();
      await FirebaseFirestore.instance.collection("Conversations/${widget.recieverUserId}/OpenConversations").doc(sender!.uid).delete();
    }
    super.dispose();
  }

  void _sendMessageButton(String value) async {
    sentMessage = true;
    _controller.clear();

    var message = {
      "user": sender!.uid,
      "Message": value
    };

    await FirebaseFirestore.instance.collection("MessageLogs").doc(messageLogReference!.id).update({
      "Messages": FieldValue.arrayUnion([message])
    });
    setState(() {
      messages.add(message);
    });
  }

  Future<Map<String, dynamic>> buildInfo() async {
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
        buildMessageScreen(recipientData["senderPfp"]),
        buildMessageBar()
      ],
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
                return MessageBlob(currentUser: sender!.uid, messageSender: messages[index]["user"], senderProfilePicture: senderPfp, messageContents: messages[index]["Message"]);
              },
              childCount: messages.length),
            )
          ],)
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
/*

  final List<Map<String, String>> dummyConversations = [
    {
      'username': 'user1',
      'lastMessage': 'Hey, how are you?',
    },
    {
      'username': 'user2',
      'lastMessage': 'Looking forward to our meeting!',
    },
    {
      'username': 'user3',
      'lastMessage': 'Can you send the files?',
    },
    {
      'username': 'user4',
      'lastMessage': 'Thanks for your help!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Direct Messages"),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: dummyConversations.length,
        itemBuilder: (context, index) {
          var conversation = dummyConversations[index];
          var username = conversation['username']!;
          var lastMessage = conversation['lastMessage']!;

          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/bloop.jpg'),
            ),
            title: Text(
              username,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              lastMessage,
              style: const TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
            ),
            onTap: () {
              // Handle opening conversation details in the future
            },
          );
        },
      ),
    );
  }*/
  
}