import 'dart:developer';
import 'package:cs4900/main.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/main.dart';



class UploadScreen extends StatelessWidget {
  final String imagePath;
  UploadScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text("Upload"),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
    );

    Column body = Column(
      children: [

      ]
    );

    Scaffold result = Scaffold(
      appBar: appBar,
      body: body,
    );

    return result;
  }
}