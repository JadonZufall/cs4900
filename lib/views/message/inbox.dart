import 'dart:developer';

import 'package:cs4900/auth.dart';
import 'package:cs4900/models/user.dart';
import 'package:cs4900/views/message/single_inbox.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/util/search_util.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  InboxScreenState createState() => InboxScreenState();
}

class InboxScreenState extends State<InboxScreen> {

  User? user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String searchText = '';

  var _future;

  @override
  void initState() {
    super.initState();
    reloadConversations();
    _focusNode.addListener(_onFocusChange);
    _future = reloadConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange); // Remove listener on dispose
    _focusNode.dispose(); // Dispose the focus node
    super.dispose();
  }

  void _onFocusChange() {
    // Trigger rebuild to show/hide user list
    setState(() {});
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  Future<List<String>> reloadConversations() async {
    await FirebaseFirestore.instance.collection("Conversations").doc(user?.uid).set(
        {"newConversations" : []}
    );
    return await updateConversations();
  }

  Future<List<String>> updateConversations() async {
    List<String> conversations = [];

    var querySnapshot = await FirebaseFirestore.instance.collection("Conversations/${user!.uid}/OpenConversations").get();
    for(var docSnapshot in querySnapshot.docs) {
      UserInformation recipient = new UserInformation(docSnapshot.id);

      conversations.add(recipient.uid);
    }
    return conversations;
  }


  Widget activeInboxStreamBuilder(List<String> conversations) {
    Widget loadingState = const Center(child: CircularProgressIndicator());

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("Conversations").doc(user!.uid).snapshots(),
      builder: ((context, snapshot){
        if (snapshot.hasError) {
          log("Error in message screen stream builder");
          return Text("Error");
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return buildActiveInboxes(conversations);
        }
        else if (snapshot.hasData) {
          var conversationSet = conversations.toSet();

          for (String newCovno in snapshot.data!.get("newConversations")) {
            conversationSet.add(newCovno);
          }
          conversations = conversationSet.toList();
        }
        return buildActiveInboxes(conversations);
      })
    );
  }

  Widget buildActiveInboxes(List<String> conversations) {
    return Expanded(
      child: Container(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context,index) {
                  return InboxBlob(
                      recipientUid: conversations[index],
                  );
                },
                childCount: conversations.length),
              )
            ],
          ),
        margin: EdgeInsets.only(left: 10, right: 10)
      )
    );
  }

  Widget buildWidget(List<String> conversations) {
    return Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _onSearchChanged,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search Users',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
              )
          ),
          if (_focusNode.hasFocus || searchText.isNotEmpty)
            Expanded(
                child: Container( constraints: BoxConstraints(minHeight: 300), child: SearchHelpers.get(searchText, _focusNode, RouteNames.directMessageRoute))
            ),
          Text("Existing Conversations", style: TextStyle(color: Colors.white, fontSize: 16)),
          activeInboxStreamBuilder(conversations)
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingState = const Center(child: CircularProgressIndicator());

    FutureBuilder<List<String>> builder = FutureBuilder<List<String>> (
        future: _future,
        builder: ( context, snapshot) {
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
        title: const Text('Inbox'),
      ),
      body: builder,
    );
    
  }
}