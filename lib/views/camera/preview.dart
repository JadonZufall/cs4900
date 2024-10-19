import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cs4900/main.dart';


class PreviewPictureScreen extends StatelessWidget {
  final String imagePath;
  const PreviewPictureScreen({super.key, required this.imagePath});

  void _upload() {

  }

  void _retake() {
    navigatorKey.currentState?.pop();
    // navigatorKey.currentState?.pushNamed(RouteNames.uploadScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview")),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          ElevatedButton(onPressed: _upload, child: const Text("Upload")),
          ElevatedButton(onPressed: _retake, child: const Text("Delete")),
        ],
      ),
    );
  }
}