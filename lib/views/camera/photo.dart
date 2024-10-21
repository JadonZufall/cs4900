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

  void _galleryButton() {

  }

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

    FutureBuilder<void> cameraBuilder = FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
    );

    FloatingActionButton actionButton = FloatingActionButton(
      child: const Icon(Icons.camera),
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
    );

    BottomAppBar bottomNavBar = BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.browse_gallery, size: 30),
            onPressed: _galleryButton,
          )
        ]
      )
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Camera"),
        backgroundColor: const Color.fromRGBO(18, 25, 33, 1),
        foregroundColor: Colors.white, ),
      body: Column(children: [
        Center(child: cameraBuilder),
        
      ]),
      // bottomNavigationBar: bottomNavBar,
      floatingActionButton: actionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}