import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/util/app_colors.dart';
import 'package:cs4900/main.dart';


class InboxBlob extends StatelessWidget {
  final String? recipientUserName;
  final String? recipientUid;
  final String? lastMessage;
  final Image recipientPfp;

  const InboxBlob({super.key, required this.recipientUserName, required this.recipientPfp, required this.recipientUid, required this.lastMessage});

  @override
  Widget build(BuildContext context) {
    Center recipientInformation = Center(child: Container(
      margin: EdgeInsets.only(left:15),
      child: Row (
        children: [
          ClipOval(
            child: SizedBox(
              width: 35, height: 35,
              child: recipientPfp,
            )
          ),
          Container(
            margin: EdgeInsets.only(left:15, top: 5),
            child: Column(
              children: [
                Text(
                  recipientUserName ?? "???",
                  style: const TextStyle(fontSize:13, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    lastMessage ?? "???",
                    style: const TextStyle(fontSize:13, color: Colors.white),
                    textAlign: TextAlign.left,
                  )
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
            arguments: {'userId': recipientUid!}
        );
      },
    );
  }
}