import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cs4900/main.dart';
import 'package:cs4900/views/camera/upload.dart';
import 'package:cs4900/views/camera/edit.dart';

class PreviewPictureScreen extends StatelessWidget {
  final String imagePath;
  final UploadType uploadType;
  const PreviewPictureScreen({super.key, required this.imagePath, required this.uploadType});

  void _retake() {
    navigatorKey.currentState?.pop();
    // navigatorKey.currentState?.pushNamed(RouteNames.uploadScreenRoute);
  }

   Future<String?> _cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: const Color.fromRGBO(32, 49, 68, 1),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );

    return croppedFile?.path; // Return the path of the cropped image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Image.file(File(imagePath)),
          Row(children: [
            Center(
              child: ElevatedButton(
                onPressed: _retake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UploadScreen(imagePath: imagePath, type: uploadType),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                ),
                child: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditScreen(imagePath: imagePath, uploadType: uploadType,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                ),
                child: const Text(
                  "Add Filters",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
              Center(
              child: ElevatedButton(
              onPressed: () async {
                final croppedImagePath = await _cropImage(imagePath);
                if (croppedImagePath != null) {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          PreviewPictureScreen(imagePath: croppedImagePath, uploadType: uploadType),
                    ),
                  );
                } else {
                  // Handle the case where cropping was cancelled or failed
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cropping was cancelled.")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
              ),
              child: const Text(
                "Crop",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ),
          ]),
        ],
      ),
    );
  }
}
