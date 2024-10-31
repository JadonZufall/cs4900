import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/util/app_colors.dart';


class MessageBlob extends StatelessWidget {
  final String? messageSender;
  final String? currentUser;
  final String? messageContents;
  final Image senderProfilePicture;

  const MessageBlob({super.key, required this.currentUser, required this.messageSender, required this.senderProfilePicture, required this.messageContents});

  @override
  Widget build(BuildContext context) {
    bool sentByUser = messageSender == currentUser;

    ClipOval senderPfp = ClipOval(
      child: SizedBox(
        width: 35, height: 35,
        child: senderProfilePicture,
      )
    );

    Expanded message = Expanded(
      child: Container (
        margin: EdgeInsets.all(10),

        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                color: AppColors.lighten(AppColors.backgroundColor),
                borderRadius: BorderRadius.circular(10)
            ),
          child: Text(
            messageContents!,
            style: TextStyle(
              color: Colors.white
            ),
          )
        ),
      )
    );

    return Container(
      padding: EdgeInsets.only(left: sentByUser ? 15 : 5, right: sentByUser ? 5 : 15),
      child: Row (
        children: [
          sentByUser ? message : senderPfp,
          sentByUser ? senderPfp : message
        ],
      ),
    );
  }
}