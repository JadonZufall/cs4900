import 'package:cs4900/views/camera/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/main.dart';
import 'package:cs4900/views/camera/upload.dart';
import 'package:cs4900/views/camera/photo.dart';
import 'package:camera/camera.dart';

class UploadTypeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Image Type'),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Camera Button
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                            camera: primaryCamera as CameraDescription),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 40, // Adjust radius for size
                    backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                    child: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Spacing between buttons
                // Gallery Button
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PickImageScreen(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 40, // Adjust radius for size
                    backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                    child: Text(
                      "Gallery",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}