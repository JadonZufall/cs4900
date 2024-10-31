import 'dart:developer';

import 'package:flutter/material.dart';


class LikeButtonComponent extends StatefulWidget {
  const LikeButtonComponent({super.key});

  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButtonComponent> {
  bool isLiked = false;

  void _onPressed() {
    log("Like button pressed");
    setState(() {isLiked = !isLiked;});
  }

  @override
  Widget build(BuildContext context) {
    log("Built");
    return IconButton(
        icon: Icon(
          Icons.favorite_outline,
          size: 25,
          color: isLiked ? Colors.red : Colors.white,
        ),
        onPressed: _onPressed,
    );
  }

}