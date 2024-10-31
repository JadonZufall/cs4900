import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/models/user.dart';
import 'package:cs4900/views/profile/public_profile.dart';
import 'package:cs4900/util/search_util.dart';


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
