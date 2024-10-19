/* Contains the screens for taking pictures.
*/

import 'dart:developer';
import 'package:cs4900/main.dart';
import 'package:flutter/material.dart';
import 'package:cs4900/main.dart';
import 'package:camera/camera.dart';
import 'package:cs4900/views/camera/preview.dart';


class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TOOD: Add gallary picker.  its called image picker I think, might need to download something for it.

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if (!context.mounted) return;

            await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => PreviewPictureScreen(
                      imagePath: image.path
                  ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      )
    );
  }
}