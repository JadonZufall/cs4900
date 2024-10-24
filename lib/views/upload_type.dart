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
          children: [
            Row(children: [
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                            camera: primaryCamera as CameraDescription),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                  ),
                  child: const Text(
                    "Camera",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PickImageScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(32, 49, 68, 1),
                  ),
                  child: const Text(
                    "Gallery",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
